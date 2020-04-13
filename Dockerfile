FROM    ubuntu:18.04
# Make sure the package repository is up to date

# built-in packages
ENV DEBIAN_FRONTEND noninteractive

#Update the package manager and upgrade the system
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
	apt dist-upgrade -y 

RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    apt-get update -q && \
	apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata

# Installing fuse filesystem is not possible in docker without elevated priviliges
# but we can fake installling it to allow packages we need to install for GNOME
RUN apt-get install -y libfuse2 && \
    cd /tmp ; apt-get download fuse && \
    cd /tmp ; dpkg-deb -x fuse_* . && \
    cd /tmp ; dpkg-deb -e fuse_* && \
    cd /tmp ; rm fuse_*.deb && \
    #cd /tmp ; echo -en "#!/bin/bash\nexit 0\n" > DEBIAN/postinst && \
	cd /tmp ; echo "#!/bin/bash" | tee DEBIAN/postinst > /dev/null && \
	cd /tmp ; echo "exit 0" | tee -a DEBIAN/postinst > /dev/null && \
    cd /tmp ; dpkg-deb -b . /fuse.deb && \
    cd /tmp ; dpkg -i /fuse.deb

# Upstart and DBus have issues inside docker.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

RUN apt install -y --no-install-recommends --allow-unauthenticated sudo locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN apt-get install -y x11vnc xvfb firefox

RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated software-properties-common curl apache2-utils \
	   apt-transport-https wget curl vim netcat net-tools openssh-server gpg-agent paraview git repo\ 
	   xfonts-base xfonts-75dpi xfonts-100dpi \
       xorg ubuntu-desktop ubuntu-gnome-desktop gnome-core gnome-panel gnome-session gnome-settings-daemon metacity nautilus gnome-terminal gnome-tweak-tool \
	   xfce4 \
	   tightvncserver 

RUN apt update \
    && apt install -y --no-install-recommends \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list > /dev/null \
	&& wget https://dl.google.com/linux/linux_signing_key.pub \
	&& apt-key add linux_signing_key.pub \
	&& apt update \
	&& apt install -y google-chrome-stable \
	&& rm linux_signing_key.pub \
	&& wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - \
	#&& add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
	&& echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null \
	&& apt update \
	&& apt install code \
	&& apt autoclean -y \
	&& apt autoremove -y \
	&& rm -rf /var/lib/apt/lists/* 


# Hostname configuration
RUN echo "mycontainer" | tee /etc/hostname > /dev/null
RUN cat /etc/hostname
RUN echo "127.0.0.1	localhost" | tee -a /etc/hosts > /dev/null
RUN echo "127.0.0.1	mycontainer" | tee -a /etc/hosts > /dev/null
RUN echo "# The following lines are desirable for IPv6 capable hosts" | tee -a /etc/hosts > /dev/null
RUN echo "::1     ip6-localhost ip6-loopback" | tee -a /etc/hosts > /dev/null
RUN echo "fe00::0 ip6-localnet" | tee -a /etc/hosts > /dev/null
RUN echo "ff00::0 ip6-mcastprefix" | tee -a /etc/hosts > /dev/null
RUN echo "ff02::1 ip6-allnodes" | tee -a /etc/hosts > /dev/null
RUN echo "ff02::2 ip6-allrouters" | tee -a /etc/hosts > /dev/null
RUN cat /etc/hosts

COPY init.sh /usr/local/bin/.

# Autostart firefox (might not be the best way to do it, but it does the trick)
#RUN bash -c "echo "firefox" >> /.bashrc'

RUN useradd -ms /bin/bash asap
RUN usermod -aG sudo asap
RUN echo "asap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/asap \
    && chmod 0440 /etc/sudoers.d/asap 

# RUN mkdir /root/.vnc
RUN     mkdir -p /home/asap/.vnc

# Setup a password
# RUN     x11vnc -storepasswd 1234 /root/.vnc/passwd
RUN x11vnc -storepasswd 1234 /home/asap/.vnc/passwd

# COPY xstartup /root/.vnc/xstartup
COPY xstartup /home/asap/.vnc/xstartup

# RUN chmod 755 /root/.vnc/xstartup
RUN chown -R asap:asap /home/asap/.vnc
RUN chmod a+x /home/asap/.vnc/xstartup
RUN ls -lart /home/asap/

#RUN bash -c 'echo " /usr/bin/Xvfb :0 -screen 0 1280x1024x24 -cc 4 -nolisten tcp -auth /var/gdm/:0.Xauth && service gdm3 start" >> /.bashrc'

USER asap
WORKDIR /home/asap

CMD ["bash"]

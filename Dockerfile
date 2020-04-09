FROM    ubuntu:18.04
# Make sure the package repository is up to date
RUN     apt-get update

# built-in packages
ENV DEBIAN_FRONTEND noninteractive

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN     apt-get install -y x11vnc xvfb firefox



RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
       ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal tightvncserver\
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Autostart firefox (might not be the best way to do it, but it does the trick)
#RUN     bash -c 'echo "firefox" >> /.bashrc'

#RUN useradd -ms /bin/bash asap

#USER asap
#WORKDIR /home/asap

RUN     mkdir /root/.vnc
# Setup a password
RUN     x11vnc -storepasswd 1234 /root/.vnc/passwd

COPY xstartup /root/.vnc/xstartup

RUN chmod 755 /root/.vnc/xstartup

#RUN     bash -c 'echo " /usr/bin/Xvfb :0 -screen 0 1280x1024x24 -cc 4 -nolisten tcp -auth /var/gdm/:0.Xauth && service gdm3 start" >> /.bashrc'

CMD ["bash"]
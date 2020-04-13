README
======

This creates a Docker container with Ubuntu 18.04 and [TightVNC Server](https://tightvnc.com).

Usage

```bash
$ docker build -t xbroquer/ubuntu:18.04-gnome-vnc .

$ sudo docker run -it --rm -p 5901:5901 -e USER=asap  xbroquer/ubuntu:18.04-gnome-vnc  bash -c ' cat /home/asap/.vnc/xstartup &&  vncserver :1 -geometry 1680x1050 -depth 24 && tail -F /home/asap/.vnc/*.log'

```

Variant for gnome & xfce4

gnome desktop
```bash
$ cp xstartup.gnome xstartup
```

xfce4 desktop
```bash
$ cp xstartup.xfce4 xstartup
```
Usage

```bash
$ sudo docker build -t pascalbedouet/ubuntu:18.04-gnome-vnc .
$ sudo docker run -it --rm -p 5901:5901 -e USER=asap  pascalbedouet/ubuntu:18.04-gnome-vnc  bash -c 'cat /home/asap/.vnc/xstartup &&  vncserver :1 -geometry 1680x1050 -depth 24 && tail -F /home/asap/.vnc/*.log'
```

VNC password is 1234

README
======

This creates a Docker container with Ubuntu 18.04 and [TightVNC Server](https://tightvnc.com).

Usage

```bash
$ docker build -t xbroquer/ubuntu:18.04-gnome-vnc .

$ sudo docker run -it --rm -p 5901:5901 -e USER=asap  xbroquer/ubuntu:18.04-gnome-vnc  bash -c ' cat /home/asap/.vnc/xstartup &&  vncserver :1 -geometry 1680x1050 -depth 24 && tail -F /home/asap/.vnc/*.log'

```
VNC password is 1234

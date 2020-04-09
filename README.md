README
======

This creates a Docker container with Ubuntu 18.04 and [TightVNC Server](https://tightvnc.com).

Usage

```bash
$ docker build -t xbroquer/ubuntu:18.04-gnome-vnc .

$ docker run -it --rm -p 5901:5901 -e USER=root  xbroquer/ubuntu:18.04-gnome-vnc     bash -c " cat ~/.vnc/xstartup &&  vncserver :1 -geometry 1366x768 -depth 24 && tail -F ~/.vnc/*.log"

```
VNC password is 1234

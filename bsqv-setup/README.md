# BroadSign Player - Docker

This repository holds the necessary Dockerfiles for the auto-install Ubuntu image.

The required components are already included in the mentioned Ubuntu image, which are:

* /opt/assets/bsp
* /opt/assets/control-player-ubuntu.deb

# Notes

It is extremely important to run this image using Ubuntu on Wayland only. Otherwise BroadSign Player glitches out.

# Usage

1. Clone or copy the repo inside `/opt/`.
2. Create the necessary volumes for the images before building:

```
$ sudo docker volume create --name=broadsign-player-data
```

3. Build the image (If you are running this from an external process such as ansible, set `DISPLAY=:0` before running the build process). 

```
$ sudo docker-compose build
```

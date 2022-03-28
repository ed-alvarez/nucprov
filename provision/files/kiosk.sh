#!/bin/bash
DISPLAY=:0

xset s noblank
xset s off
xset -dpms

xhost +local:docker && cd /opt && docker-compose up -d

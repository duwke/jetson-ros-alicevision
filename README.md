# jetson-ros-alicevision
Dockerfile for AliceVision on ROS Melodic on jetson

Spefically, we are using a jetson xavier agx
https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-agx-xavier/

# Prequesites
* JetPack 4.5.1
* docker (it should be installed with JetPack 4.5.1)
* docker-compose 
  * sudo pip3 -v install docker-compose

# Build
docker build -t jetson-melodic-alicevision .
docker-compose run jetson-melodic-alicevision /bin/bash

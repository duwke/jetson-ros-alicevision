# jetson-ros-alicevision
Dockerfile for ROS Melodic on jetson with AliceVision installed

Spefically, we are using a jetson xavier agx
https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-agx-xavier/

# Notes
1. If using a nano, you should change "j8" to "j2" in the dockerfile


# Prerequisites
* JetPack 4.5.1
* docker (it should be installed with JetPack 4.5.1)
* docker-compose 
  * sudo pip3 -v install docker-compose

# Build

docker build -t jetson-melodic-alicevision .  
docker-compose run jetson-melodic-alicevision-service /bin/bash

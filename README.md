# jetson-ros-alicevision
Dockerfile for ROS Melodic on jetson with AliceVision installed

Spefically, we are using a jetson xavier agx
https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-agx-xavier/

# Notes
1. If using a nano, you should change "j8" to "j2" in the dockerfile


# Prerequisites
* JetPack 4.5.1 (installed from NVidia SDK manager
  * sudo ln -s /usr/lib/aarch64-linux-gnu/libcublas.so /usr/local/cuda/lib64/libcublas.so
* docker (it should be installed with JetPack 4.5.1)
* docker-compose 
  * sudo pip3 -v install docker-compose
  * edit /etc/docker/daemon.jetson

```
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "dns": ["10.10.10.42", "10.10.10.43", "8.8.8.8"],
    "dns-search": ["hmech.us"],
    "insecure-registries": ["10.10.10.49:5000", "docker.hmech.us:5000"],
    "log-driver": "json-file",
    "log-opts": {"max-size": "10m", "max-file": "3"},
    "data-root": "/media/aquanaut/workspace/docker_tmp",
    "default-runtime": "nvidia"

}
```


# Build

docker build -t jetson-melodic-alicevision .  
docker-compose run jetson-melodic-alicevision-service /bin/bash

FROM nvcr.io/nvidia/l4t-base:r32.3.1

# add new sudo user
ENV USERNAME melodic
ENV HOME /home/$USERNAME
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod  --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME && \
    gpasswd -a $USERNAME video

# install package
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    # tools
    sudo \
    build-essential \
    git \
    less \
    emacs \
    tmux \
    bash-completion \
    command-not-found \
    software-properties-common \
    xdg-user-dirs \
    xsel \
    dirmngr \
    gpg-agent \
    mesa-utils \
    libglu1-mesa-dev \
    libgles2-mesa-dev \
    freeglut3-dev \
    # qt
    python3 xcb libxkbcommon-x11-0 wget tar python3-pip python3-setuptools \
    qttools5-dev               \
    qtdeclarative5-dev         \
    qtpositioning5-dev         \
    qtbase5-dev               \
    libgtk-3-dev libxcb-xinerama0-dev \
    llvm-6.0 \
    clang-6.0 \ 
    libclang-6.0-dev \ 
    # alicevision
    libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev \
    libboost-all-dev \
    libopenjp2-7-dev \
    libturbojpeg \
    libbz2-dev \
    libraw-dev \
    libwebp-dev \
    ptex-base \
    libsquish-dev \
    libheif-dev \
    libopenvdb-tools \
    libdcmtk-dev \
    libptexenc-dev \
    libgif-dev \
    libfreetype6-dev \
    libopencolorio-dev \
    libffms2-dev \
    libopenvdb-dev \
    libturbojpeg0-dev \
    libeigen3-dev \
    libceres-dev \
    graphviz \
    doxygen \
    python3-sphinx

WORKDIR /home/$USERNAME/workspace/src
# cmake 3.20
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && \
    tar -zxvf cmake-3.20.0.tar.gz && \
    cd cmake-3.20.0 && \
    ./bootstrap && \
    make -j8  && \
    sudo make install 

# alicevision
RUN git clone https://github.com/alicevision/AliceVision.git --recursive && \
    cd AliceVision && \
    mkdir build && \
    cd build && \
    cmake .. -DALICEVISION_BUILD_DEPENDENCIES=ON && \
    make -j8 && \
    make install

# # necessary for sudo apt-get build-dep qt5-default
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update && \
    apt-get build-dep qt5-default

ENV LLVM_INSTALL_DIR=/usr/lib/clang/6

# qt
WORKDIR /home/$USERNAME/workspace/src
RUN wget http://master.qt.io/archive/qt/5.15/5.15.2/submodules/qt-everywhere-src-5.15.2.tar.xz && \
    tar xpf qt-everywhere-src-5.15.2.tar.xz && \
    cd qt-everywhere-src-5.15.2  && \
    ./configure -xcb -confirm-license -opensource -nomake examples -nomake tests && \
    make -j8 && \
    make install
        
WORKDIR /home/$USERNAME/workspace/src
RUN git clone http://code.qt.io/pyside/pyside-setup.git && \
    cd pyside-setup && \
    git checkout 5.14.1 && \
    python3 setup.py install --qmake=/usr/local/Qt-5.15.2/bin/qmake  --parallel=8

WORKDIR /home/$USERNAME/workspace/src
RUN git clone https://github.com/aharbick/meshroom && \
    sudo apt-get install python3 python3-venv && \
    cd meshroom && python3 -m venv venv && \
    . venv/bin/activate && \
    pip install wheel && \
    pip install -r requirements.txt


# ROS Melodic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-desktop-full \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN rosdep init

USER $USERNAME
WORKDIR /home/$USERNAME
RUN rosdep update
SHELL ["/bin/bash", "-c"]
RUN echo "export PATH=/usr/local/cuda/bin:$PATH" >> ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc && \
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && \
    source ~/.bashrc

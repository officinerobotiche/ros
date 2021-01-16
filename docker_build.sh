#!/bin/bash
# Copyright (C) 2021, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

bold=`tput bold`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

# Load variables
source ./utils/variables.sh

# https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables
GITHUB_REPOSITORY=$1
echo "GITHUB_REPOSITORY=$GITHUB_REPOSITORY"
GITHUB_ACTOR=$2
echo "GITHUB_ACTOR=$GITHUB_ACTOR"

TAG_IMAGE="ros:$ROS_DISTRO-ros-core-l4t-$L4T_VERSION-cv-$OPENCV"

if [ ! -d jetson-containers ] ; then
    echo " - ${bold}Download ${green}jetson-containers${reset}"
    git clone https://github.com/dusty-nv/jetson-containers.git
else
    echo " - ${bold}Update ${green}jetson-containers${reset}"
    cd jetson-containers
    git pull
    cd ..
fi

## Configuration
echo "-------------------"
echo "L4T: $L4T_VERSION"
echo "Open-CV: $OPENCV"
echo "ROS Distro: $ROS_DISTRO"
echo "Base image: $BASE_IMAGE"
echo "ROS Pkg: $ROS_PKG"
echo "-------------------"
echo "Output image: $TAG_IMAGE"
echo "-------------------"

echo " - ${bold}Build ${green}$TAG_IMAGE${reset}"
## Build Docker image with 
cd jetson-containers
docker build -f Dockerfile.ros.$ROS_DISTRO -t $TAG_IMAGE --build-arg BASE_IMAGE=fix_certificates:$L4T_VERSION --build-arg ROS_PKG=$ROS_PKG .

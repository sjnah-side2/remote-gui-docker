FROM nvidia/opengl:1.1-glvnd-devel-ubuntu18.04

# Add glxgears for OpenGL test
RUN apt-get update && apt-get install -y mesa-utils

# Switch to user
RUN useradd -rm -d /home/username -s /bin/bash -g root -G sudo -u 1001 username
USER username
WORKDIR /home/username
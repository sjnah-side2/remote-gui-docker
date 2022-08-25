#!/bin/bash

# Download base image
docker pull nvidia/opengl:1.1-glvnd-devel-ubuntu18.04

# Build our image
docker build -t gui-test:origin  ./dockerfile
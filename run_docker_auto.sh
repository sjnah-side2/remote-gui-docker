#!/bin/bash

# Add bash color for logging
RED='\033[0;31m'
YELLOW='\033[1;33m'
Cyan='\033[0;36m'
NC='\033[0m'

function allowXhost {
  # Allow connection to X server
  xhost +local: &> /dev/null
}

function startDockerLocally {
  # Allow connection to X Server
  allowXhost

  # Run docker
  echo -e "${Cyan}=============== Docker start ================${NC}"
  docker run -it \
    --gpus all \
    --network=host \
    --ipc=host \
    --env=DISPLAY=$DISPLAY \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${HOME}/.Xauthority:/root/.Xauthority:ro" \
    --name="gui-test-local" \
    gui-test:origin \
    /bin/bash
}

function startDockerRemotely {
  # Allow connection to X Server
  allowXhost

  # Run docker
  echo -e "${Cyan}=============== Docker start ================${NC}"
  docker run -it \
    --user=root \
    --network=host \
    --ipc=host \
    --env=DISPLAY=$DISPLAY \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${HOME}/.Xauthority:/root/.Xauthority:ro" \
    --name="gui-test-remote" \
    gui-test:origin \
    /bin/bash
}

function attachDocker {
  echo -e "${Cyan}=============== Docker start ================${NC}"
  docker exec -it gui-test-${USER_LOCATION} /bin/bash
}

# Check user location whether local or remote
if [ "$(who am i)" = "" ]; then
    USER_LOCATION="local"
else
    USER_LOCATION="remote"
fi

# Check if the container is running
CONTAINER_STATE=$(docker inspect --format='{{json .State.Running}}' gui-test-${USER_LOCATION}) 

# If there is no container
if [ $? -eq 1 ]; then
    echo "[INFO] There is no running container."

    # Start Docker
    if [ "${USER_LOCATION}" = "local" ]; then
      echo "[INFO] Start Docker container in local PC."
      startDockerLocally
    elif [ "${USER_LOCATION}" = "remote" ]; then
      echo "[INFO] Start Docker container in remote server."
      startDockerRemotely
    fi
    exit
fi

# If there is container
if [ "${CONTAINER_STATE}" = "true" ]; then
  # Attach to running container
  echo -e "[INFO] gui-test-${USER_LOCATION} container is already running. You'll attach to running container."

  # Allow connection to X Server
  allowXhost

  # Attach to docker container
  attachDocker
  exit
else
  # There is previous exited container. If we restart container, image will be initialized
  echo -e "${YELLOW}[WARN] We find dead container. previous container will be removed and restart. ${NC}"
  read -r -p $'\e[1;33m[WARN] Then container image will be initialized. Are you sure? [y/N] \e[0m: ' response

  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    # Remove previous container
    docker rm gui-test-${USER_LOCATION} &> /dev/null

    if [ "${USER_LOCATION}" = "local" ]; then
      echo "[INFO] Restart Docker container in local PC."
      startDockerLocally
    elif [ "${USER_LOCATION}" = "remote" ]; then
      echo "[INFO] Restart Docker container in remote server."
      startDockerRemotely
    fi
    exit
  else
    echo -e "${YELLOW}[WARN] Script is terminated. Please back up your image first. ${NC}"
    exit
  fi
fi
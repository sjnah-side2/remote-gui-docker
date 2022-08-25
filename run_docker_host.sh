#!/bin/bash

# Stop and remove previous container
docker stop gui-test-host && docker rm gui-test-host

# Allow connection to X server
xhost +local:

docker run -it \
    --gpus all \
	--network=host \
	--env=DISPLAY=$DISPLAY \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="${HOME}/.Xauthority:/root/.Xauthority:ro" \
    --name="gui-test-host" \
	gui-test:origin \
	/bin/bash   
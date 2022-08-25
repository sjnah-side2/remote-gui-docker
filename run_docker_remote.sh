#!/bin/bash

# Stop and remove previous container
docker stop gui-test-remote && docker rm gui-test-remote

# Allow connection to X server
xhost +local:

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
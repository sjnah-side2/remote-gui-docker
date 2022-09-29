# X11 Forwarding on remote docker

You have to install X11-Server (like Xming) on remote PC.
and this docker setup use `--network=host`. 

If you don't want to use `--network=host`, you have to change docker setup `--env=DISPLAY=$DISPLAY` to `--env=DISPLAY=$YOUR_DOCKER_IP:0`.
- `host`: remote server
- `docker`: docker container on remote server

## 1. Setup ssh forwarding config


### Install x11 on remote server

```bash
(host)$ apt-get update
(host)$ apt-get install x11-apps
```
### Set ssh configuration on remote server

```bash
(host)$ sudo vim /etc/ssh/sshd_config
...
X11Forwarding yes
X11UseLocalhost no
...
```

## 2. Build & Run docker

You can build image with `build_docker.sh` bash script.
And `run_docker_auto.sh` will run container automatically whether local access, remote access or attach.

```bash
(host)$ bash build_docker.sh
(host)$ bash run_docker_auto.sh
```


## 3. Test OpenGL on remote PC

```bash
(docker)$ glxgears
```

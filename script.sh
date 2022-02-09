#!/bin/bash
NAME="curriculum"
MAJOR_VERSION_NUM=2
MINOR_VERSION_NUM=1

USERNAME="user"

DEV_ENABLED="true"
SSH_KEY_NAME="id_ed25519"




CONTAINER_NAME="${NAME}_${MAJOR_VERSION_NUM}_${MINOR_VERSION_NUM}"
DOCKER_IMAGE_NAME="${NAME}_img_${MAJOR_VERSION_NUM}_${MINOR_VERSION_NUM}"

setfacl -m user:1000:r ${HOME}/.Xauthority
dpkg -l | grep nvidia-container-toolkit &> /dev/null
HAS_NVIDIA_TOOLKIT=$?
which nvidia-docker > /dev/null
HAS_NVIDIA_DOCKER=$?

DOCKER_BASE_IMAGE="nvidia/opengl:1.2-glvnd-devel-ubuntu20.04"
if [ $HAS_NVIDIA_TOOLKIT -eq 0 ]; then
  docker_version=`docker version --format '{{.Client.Version}}' | cut -d. -f1`
  if [ $docker_version -ge 19 ]; then
	  DOCKER_COMMAND="docker run --gpus all"
  else
	  DOCKER_COMMAND="docker run --runtime=nvidia"
  fi
elif [ $HAS_NVIDIA_DOCKER -eq 0 ]; then
  DOCKER_COMMAND="nvidia-docker run"
else
  DOCKER_BASE_IMAGE="ubuntu:focal"
  DOCKER_COMMAND="docker run"
fi

if [[ $DEV_ENABLED == "true" ]]; then
docker build -t $DOCKER_IMAGE_NAME \
  --build-arg username=$USERNAME \
  --build-arg base_img=$DOCKER_BASE_IMAGE \
  --build-arg dev_enabled=$DEV_ENABLED \
  --build-arg git_email="$(git config user.email)" \
  --build-arg git_name="$(git config user.name)" \
  --build-arg ssh_file_name=$SSH_KEY_NAME \
  --build-arg ssh_prv_key="$(cat ~/.ssh/$SSH_KEY_NAME)" \
  --build-arg ssh_pub_key="$(cat ~/.ssh/$SSH_KEY_NAME.pub)" \
  --squash  .
else
docker build -t $DOCKER_IMAGE_NAME \
  --build-arg username=$USERNAME \
  --build-arg base_img=$DOCKER_BASE_IMAGE \
  --build-arg dev_enabled=$DEV_ENABLED \
  .
fi

exec $DOCKER_COMMAND \
     -it \
     --name $CONTAINER_NAME\
     --net=host \
     -e DISPLAY \
     -e QT_X11_NO_MITSHM=1 \
     --device=/dev/input \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v "$HOME/exchange:/home/$USERNAME/exchange" \
     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
     -v ${HOME}/.Xauthority:/home/$USERNAME/.Xauthority \
     $DOCKER_IMAGE_NAME

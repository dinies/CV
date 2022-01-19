ARG base_img
FROM $base_img

ARG username
ARG base_img

ARG DEBIAN_FRONTEND=noninteractive

ENV USERNAME $username

ENV DISPLAY :0

RUN apt-get update -qq 
RUN apt-get install -y \
  sudo \
  vim \
  tmux \
  keyboard-configuration\
  git \
  texlive-full

# sudoers 
RUN useradd -ms /bin/bash ${USERNAME} && \
  echo "$USERNAME:$USERNAME" | chpasswd && \
  usermod -aG sudo $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
  chmod 440 /etc/sudoers.d/$USERNAME


WORKDIR /home/$USERNAME
RUN mkdir -p /home/$USERNAME/CV
COPY . /home/$USERNAME/CV

ENTRYPOINT ["/bin/bash"]

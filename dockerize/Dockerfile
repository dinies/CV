ARG base_img
FROM $base_img

ARG username
ARG dev_enabled
ARG ssh_file_name
ARG ssh_prv_key
ARG ssh_pub_key
ARG git_name
ARG git_email

ARG DEBIAN_FRONTEND=noninteractive

ENV USERNAME $username

ENV DISPLAY :0

RUN apt-get update -qq 
RUN apt-get install -y \
  sudo \
  keyboard-configuration\
  openssh-server \
  make \
  texlive-full


# sudoers 
RUN useradd -ms /bin/bash ${USERNAME} && \
  echo "$USERNAME:$USERNAME" | chpasswd && \
  usermod -aG sudo $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
  chmod 440 /etc/sudoers.d/$USERNAME


USER $USERNAME
WORKDIR /home/$USERNAME
ARG ssh_dir_path=/home/$USERNAME/.ssh
RUN if [ "$dev_enabled" = "true" ]; then \
    mkdir -p $ssh_dir_path && \
    ssh-keyscan github.com >> $ssh_dir_path/known_hosts && \
    ssh-keyscan gitlab.inria.fr >> $ssh_dir_path/known_hosts && \
    echo "$ssh_prv_key" > $ssh_dir_path/$ssh_file_name && \
    echo "$ssh_pub_key" > $ssh_dir_path/$ssh_file_name.pub  && \
    sudo chmod 600 $ssh_dir_path/$ssh_file_name && \
    sudo chmod 600 $ssh_dir_path/$ssh_file_name.pub && \
    sudo apt-get install -y  git vim locate gdb silversearcher-ag tree tmux clang-format && \
    git config --global user.name "$git_name" && \
    git config --global user.email "$git_email" && \
    git config --global push.default simple && \
    git clone git@github.com:dinies/dotfiles.git; \ 
fi

WORKDIR /home/$USERNAME
RUN mkdir -p /home/$USERNAME/CV
COPY --chown=$USERNAME:$USERNAME . /home/$USERNAME/CV

ENTRYPOINT ["/bin/bash"]

# Потомок базового изображения Ubuntu
FROM ubuntu:latest
# Установка необходимых пакетов
RUN apt-get update && \
apt-get install -y --no-install-recommends \
software-properties-common \
python3 \
python3-pip \
python3-hvac \
virtualenv \
ansible \
openssh-server \
curl && \
rm -rf /var/lib/apt/lists/*
# Добавление репозитория Ansible
RUN add-apt-repository ppa:ansible/ansible
# Обновление пакетов и установка Ansible
RUN apt-get update && \
apt-get install -y --no-install-recommends ansible && \
rm -rf /var/lib/apt/lists/*
RUN ansible-galaxy collection install community.docker community.hashi_vault
# Создание рабочего каталога Ansible
WORKDIR /ansible
# Настройка SSH-демона на старт по умолчанию
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
mkdir -p /run/sshd
# Установка флага для Ansible, чтобы не проверять SSH-ключи хостов
ENV ANSIBLE_HOST_KEY_CHECKING=false
# Установка точки входа для управления контейнером
ENTRYPOINT ["/bin/bash"]

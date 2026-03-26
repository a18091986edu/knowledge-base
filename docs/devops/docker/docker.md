

- Контейнер - полностью изолированная среда со своими процессами и службами, собственными интерфейсами. это похоже на виртуальные машины за исключением того, что все они используют одно и то же ядро операционной системы. docker использует контейнера lxc 

- Образ - пакет или шаблон используемый для создания одного или нескольких контейнеров

## Установка 

curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh

## Основные команды

???+ tip "Основные команды"
{% include "devops/docker/parts/docker-commands.md" %}

## Portainer

```
sudo docker volume create portainer_data

sudo docker run -d \
-p 8000:8000 \
-p 9443:9443 \
--name portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
portainer/portainer-ce:lts

```

## Полезное

- [DocsDocker](https://docs.docker.com/)

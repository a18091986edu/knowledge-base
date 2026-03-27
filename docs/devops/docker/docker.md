

- Контейнер - полностью изолированная среда со своими процессами и службами, собственными интерфейсами. это похоже на виртуальные машины за исключением того, что все они используют одно и то же ядро операционной системы. docker использует контейнера lxc 

- Образ - пакет или шаблон используемый для создания одного или нескольких контейнеров

## Установка 

```
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh
sudo usermod -aG docker $USER
```


## Основные команды

??? tip "Основные команды"
{% include "devops/docker/parts/docker-commands.md" %}


## Dockerfile

??? tip "Dockerfile"
{% include "devops/docker/parts/dockerfile.md" %}

## Публикация образа в dockerhub
    # 1. Сборка образа
    docker build -t myapp:latest .

    # 2. Логин в Docker Hub
    docker login

    # 3. Тегирование для Docker Hub
    docker tag myapp:latest username/myapp:latest

    # 4. Отправка в Docker Hub
    docker push username/myapp:latest

    # 5. Запуск с Docker Hub (на любом сервере)
    docker run -d -p 1111:1111 --name myapp username/myapp:latest

## Docker Compose 

### Yml

??? tip "Docker Compose"
{% include "devops/docker/parts/docker-compose-example.md" %}

## Docker Compose Команды

??? tip "Основные команды"
{% include "devops/docker/parts/docker-compose-commands.md" %}

## Docker API

## Cgroups (ограничение ресурсов)
```bash
docker run --cpus=.5 nginx # ограничение на использование не более 50% CPU
docker run --memory=100mb nginx
docker stats --no-stream # показать потребление ресурсов контейнерами
```

## Хранилище
```bash
/var/lib/docker # по умолчанию после устовки тут Docker хранит данные
    |_image
    |_volumes
    |   |_ data_volume
    |   
    |_containers
```

## Networks

- по умолчанию:
    - bridge (по умолчанию 172.17.0.)
    - none
    - host
    - overlay
    - macvlan
    - 3rdpartyplugins
- пользовательские:
    - docker network create --driver bridge --subnet 182.18.0.0/16 my_net
    - docker network connect network container
- докер имеет встроенный DNS сервер, поэтому лучше адресацию осуществлять по имен
- docker network ls - посмотреть имеющиеся сети
- docker inspect container - посмотреть данные о его сетевых настройках
- docker inspect network - посмотреть данные о сети

## Docker registry

[Rotoro Stepik](https://stepik.org/lesson/770331/step/1?unit=772786)

Docker Swarm 

[Rotoro Stepik](https://stepik.org/lesson/770333/step/1?unit=772788)

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
- [HUB](https://hub.docker.com/)

## Курсы | Материалы

- [STEPIK | Docker для начинающих + практический опыт](https://stepik.org/course/123300/syllabus)
- [RotoroCloud](https://rotoro.cloud/landing.html)

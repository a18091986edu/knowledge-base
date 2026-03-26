    ```bash
    ############ Сборка ############

    docker build -t myapp:latest .
    - -t myapp:latest # имя и тег
    - -t myapp:v1.0 -t myapp:latest
    - -f Dockerfile.prod # указать альтернативный Dockerfile
    - . # контекст сборки (текущая директория)
    - --no-cache # не использовать кэш
    - --quiet или -q # выводить только ID образа
    - --ssh default # пробросить SSH-агент

    
    ############### Работа с контейнерами ###############

    docker run -d --rm -p 8000:8000 --name myapp myapp:latest
    - -d # detached режим
    - --rm # автоматически удалять при остановке
    - --restart unless-stopped # политика перезапуска
    - --memory="512m" # лимит памяти
    - --cpus="1.5" # лимит CPU
    - -e KEY=value # переменные окружения
    - --env-file .env # файл с переменными
    - -v /host:/container # монтирование тома
    - --mount type=bind,src=/host,dst=/container # расширенное монтирование
    - -P # опубликовать все EXPOSE порты (случайные порты хоста)
    - --network host # использовать сеть хоста
    - --network mynet # подключить к пользовательской сети
    - --name # имя контейнера
    - --log-opt max-size=10m
    - -p # сопоставление порта хоста (первый) и контейнера (второй)
    
    - docker exec -it myapp bash # вход в контейнер
    - docker attach # подключает терминал к запущенному контейнеру

    - docker ps # просмотр запущенных контейнеров
    - -a # просмотр всех (не только запущенных контейнеров)   

    - docker stop myapp  # Остановка контейнера
    - docker rm myapp # Удаление контейнера
    - docker container prune # удалить остановленные контейнеры
    - docker container prune -f # пропускать подтверждение
    - docker rm $(docker ps -aq -f status=exited) # аналогично
    - docker rm -f $(docker ps -aq) # удалить все контейнеры, включая запущенные

    - docker inspect name | id # детальная картина о контейнере
    - docker logs name | id # просмотр логов


    
    ############### Работа с образами ###############

    docker images # показать образы
    docker history # посмотреть информацию о слоях docker образа
    docker rmi myapp:latest # удалить образ
    docker pull image # скачать образ, чтобы он хранился локально
    docker image prune -a -f # удалить все неиспользуемые образы без подтверждениий
    docker rmi -f $(docker images -q) # удалить все образы
    

    ##################################################

    docker system prune -a -f # удалить всё неиспользуемой (образы, контейнеры, сети, тома)
    ```
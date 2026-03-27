    ```
    # Запуск всех сервисов
    docker compose up

    # Запуск в фоновом режиме
    docker compose up -d

    # Управление количеством реплик определенной службы
    docker compose up -d --scale service=N

    # Остановка всех сервисов
    docker compose down

    # Остановка с удалением томов (очистка данных)
    docker compose down -v

    # Пересборка образов и запуск
    docker compose up --build

    # Просмотр логов
    docker compose logs

    # Просмотр логов конкретного сервиса
    docker compose logs backend

    # Выполнение команды в контейнере
    docker compose exec backend python manage.py migrate

    # Просмотр статуса сервисов
    docker compose ps

    # Остановка и удаление всего (контейнеры, сети, тома)
    docker compose down -v --rmi all
    ```
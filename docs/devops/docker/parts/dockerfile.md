    ```dockerfile
    FROM python:3.12-slim

    RUN pip install --no-cache-dir uv

    WORKDIR /app

    RUN uv pip install --system --no-cache fastapi uvicorn

    COPY app.py .

    EXPOSE 1111

    CMD ["uv", "run", "python", "app.py"] # большая гибкость. можем запустить контейнер со своими параметрами
    # ENTRYPOINT ["uv", "run", "python", "app.py"] # указываем жестко команду которая выполняется при старте, и можем добавить ей аргументов при запуске контейнера
    # ENTRYPOINT ["sleep", "5"] -> docker run image [10] / docker run --entrypoint [command] name
    # CMD ["sleep", "5"] -> docker run image [sleep 10]
    #####################################################################################
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

    ```
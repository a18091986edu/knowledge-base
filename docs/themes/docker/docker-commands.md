```bash
# Основные команды Docker

# Сборка образа
docker build -t myapp:latest .

# Запуск контейнера
docker run -d -p 8000:8000 --name myapp myapp:latest

# Просмотр запущенных контейнеров
docker ps

# Просмотр всех контейнеров
docker ps -a

# Просмотр образов
docker images

# Остановка контейнера
docker stop myapp

# Удаление контейнера
docker rm myapp

# Удаление образа
docker rmi myapp:latest

# Просмотр логов
docker logs myapp

# Вход в контейнер
docker exec -it myapp bash
```
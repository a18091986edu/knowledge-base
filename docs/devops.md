# DevOps

## Программа изучения

### 1. Основы Linux
[Перейти к разделу](#linux) - Базовые команды и скрипты

### 2. Docker
[Перейти к разделу](#docker) - Контейнеризация приложений

### 3. Kubernetes
[Перейти к разделу](#kubernetes) - Оркестрация контейнеров

### 4. CI/CD
[Перейти к разделу](#cicd) - Непрерывная интеграция и доставка

### 5. Мониторинг
[Перейти к разделу](#monitoring) - Системы мониторинга

---

## Linux {#linux}

### Полезные команды

??? example "Основные команды для DevOps"
    ```bash
    # Просмотр процессов
    ps aux | grep nginx
    
    # Мониторинг ресурсов
    htop
    
    # Логи
    tail -f /var/log/syslog
    
    # Сеть
    netstat -tulpn

## Docker {#docker}

### Основные команды

??? tip "Базовые команды Docker"

# Запуск контейнера
docker run -d -p 80:80 nginx

# Просмотр запущенных контейнеров
docker ps

# Вход в контейнер
docker exec -it container_id bash

# Остановка всех контейнеров
docker stop $(docker ps -aq)

??? example "Docker Compose"

version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgresql://db:5432/app
  
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
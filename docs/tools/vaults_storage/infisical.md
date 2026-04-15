# 🔐 Установка Infisical (Docker)

---

??? tip "📥 Подготовка: скачать docker-compose и .env"

    ```bash
    # Скачать docker-compose файл
    curl -o docker-compose.prod.yml https://raw.githubusercontent.com/Infisical/infisical/main/docker-compose.prod.yml

    # Скачать пример переменных окружения
    curl -o .env https://raw.githubusercontent.com/Infisical/infisical/main/.env.example
    ```

---

??? tip "🔑 Генерация ключей"

    ```bash
    # Encryption Key (128-bit hex)
    openssl rand -hex 16

    # Auth Secret (256-bit base64)
    openssl rand -base64 32
    ```

---

??? tip "⚙️ Настройка .env"

    ```env
    # 🔐 Безопасность
    ENCRYPTION_KEY=ваш_hex_ключ
    AUTH_SECRET=ваш_base64_секрет

    # 🗄 База данных
    POSTGRES_USER=infisical
    POSTGRES_PASSWORD=сильный_пароль
    POSTGRES_DB=infisicaldb

    # 🌐 Адрес сайта
    SITE_URL=http://localhost:80
    ```

    ⚠️ Важно:
    - Используй реальные сгенерированные ключи
    - В продакшене обязательно HTTPS

---

??? tip "🚀 Запуск"

    ```bash
    docker compose -f docker-compose.prod.yml up -d
    ```

---

??? tip "📊 Проверка статуса"

    ```bash
    docker compose -f docker-compose.prod.yml ps
    ```

---

??? tip "💾 Резервное копирование базы"

    ```bash
    docker compose -f docker-compose.prod.yml exec db \
      pg_dump -U infisical infisical > backup_$(date +%Y%m%d).sql
    ```

---

??? tip "🌐 Доступ"

    - UI:
      http://localhost:80

    - Swagger / API docs:
      http://localhost:80/api/docs

---

??? warning "❗ Важно"

    - Если меняешь порт → измени его и в docker-compose
    - Не используй localhost в проде → укажи IP или домен
    - Проверь:
        - контейнеры запущены
        - база доступна
        - переменные окружения корректны

---

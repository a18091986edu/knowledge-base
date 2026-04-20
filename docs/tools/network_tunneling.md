## 🌐 Tunneling tools (ngrok и альтернативы)

---

??? tip "🌐 Обзор и использование tunneling-инструментов"

    Tunneling tools позволяют пробросить локальный сервис (например FastAPI, nginx, webhook) в интернет через публичный URL.

    ---
    ## 📊 Сравнение инструментов

    | Инструмент            | Простота        | Работает на VPS | Стабильность   | Фичи        | Когда использовать |
    |----------------------|-----------------|-----------------|----------------|-------------|-------------------|
    | Cloudflare Tunnel    | ⚠️ средне       | ✅ да           | 🔥 высокая     | 🔥 много    | прод / VPS        |
    | LocalTunnel          | 🔥 очень легко  | ⚠️ иногда       | ❌ слабая      | ❌ мало     | быстрый тест      |
    | Pinggy               | 🔥 легко        | ✅ да           | 👍 норм        | 👍 есть     | dev / ssh         |
    | frp                  | ⚠️ сложно       | ✅ да           | 🔥 топ         | 🔥 максимум | свой infra        |
    | localhost.run        | 🔥 легко        | ⚠️              | ❌ слабая      | ❌          | быстро и просто   |
    | ngrok                | 🔥 легко        | ❌ часто нет    | 👍 норм        | 👍 есть     | локальная разработка |

    ---

    ## ☁️ Cloudflare Tunnel (рекомендуется для VPS)

    ### Регистрация
    1. Создать аккаунт: https://dash.cloudflare.com
    2. (Опционально) добавить домен

    ### Установка
    ```bash
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared-linux-amd64.deb
    ```

    ### Авторизация
    ```bash
    cloudflared tunnel login
    ```

    ### Быстрый запуск
    ```bash
    cloudflared tunnel --url http://localhost:8000
    ```

    ### Постоянный туннель
    ```bash
    cloudflared tunnel create my-tunnel
    cloudflared tunnel route dns my-tunnel api.example.com
    cloudflared tunnel run my-tunnel
    ```

    ---

    ## 🚀 ngrok

    ### Регистрация
    https://ngrok.com → получить authtoken

    ### Установка
    ```bash
    apt install ngrok
    ```

    ### Авторизация
    ```bash
    ngrok config add-authtoken TOKEN
    ```

    ### Запуск
    ```bash
    ngrok http 8000
    ```

    ### Особенности
    - ❗ может не работать на VPS (блокировка IP)
    - URL меняется

    ---

    ## ⚡ LocalTunnel

    ### Установка
    ```bash
    npm install -g localtunnel
    ```

    ### Запуск
    ```bash
    lt --port 8000
    ```

    ### Или без установки
    ```bash
    npx localtunnel --port 8000
    ```

    ### Особенности
    - без регистрации
    - нестабильный
    - подходит для быстрых тестов

    ---

    ## 🔌 Pinggy

    ### Установка
    ❌ не требуется (работает через SSH)

    ### Запуск
    ```bash
    ssh -R 80:localhost:8000 pinggy.io
    ```

    ### Особенности
    - работает сразу
    - поддерживает HTTP / TCP / UDP
    - есть web UI

    ---

    ## 🧠 frp (Fast Reverse Proxy)

    ### Установка
    ```bash
    wget https://github.com/fatedier/frp/releases/latest/download/frp_*.tar.gz
    tar -xzf frp_*.tar.gz
    ```

    ### Сервер (frps.ini)
    ```ini
    [common]
    bind_port = 7000
    ```

    ```bash
    ./frps -c frps.ini
    ```

    ### Клиент (frpc.ini)
    ```ini
    [common]
    server_addr = SERVER_IP
    server_port = 7000

    [web]
    type = http
    local_port = 8000
    custom_domains = example.com
    ```

    ```bash
    ./frpc -c frpc.ini
    ```

    ### Особенности
    - полный контроль
    - нужен свой сервер
    - подходит для продакшена

    ---

    ## 🌍 localhost.run

    ### Запуск
    ```bash
    ssh -R 80:localhost:8000 localhost.run
    ```

    ### Особенности
    - без установки
    - быстрый старт
    - нестабильный

    ---

    ## 💡 Рекомендации

    - Для VPS → **Cloudflare Tunnel**
    - Для полной кастомизации → **frp**
    - Для быстрого теста → **LocalTunnel / localhost.run**
    - Для SSH-решений → **Pinggy**
    - Для локальной разработки → **ngrok**

    ---
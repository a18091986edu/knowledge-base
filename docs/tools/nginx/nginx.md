- [Хабр](https://habr.com/ru/companies/gnivc/articles/977196/){target='_blank'}


## 🔐 Vault + FastAPI + Nginx Proxy Manager Stack

---
??? tip "📦 Полная инфраструктура (Vaultwarden + FastAPI + NPM)"

    ## 🧭 Общая архитектура

    Система состоит из трёх сервисов:

    - Vaultwarden — хранилище паролей (Bitwarden-compatible)
    - FastAPI (fapi) — API-обёртка над Bitwarden CLI
    - Nginx Proxy Manager — reverse proxy + SSL

    Все сервисы работают в Docker сети `shared-network`.

    ---

    ```text
    containers/
    ├── fapi/
    │   ├── docker-compose.yml
    │   ├── Dockerfile
    │   ├── fapi.py
    │   └── requirements.txt
    │
    ├── nginx_proxy_manager/
    │   └── docker-compose.yml
    │
    └── vault/
        └── docker-compose.yml
    ```

    ---

    # 🔐 Vaultwarden

    ## docker-compose.yml

    ```yaml
    services:
      vaultwarden:
        image: vaultwarden/server:latest
        container_name: vaultwarden
        restart: unless-stopped
        environment:
          DOMAIN: "https://vault.itkvadrat.ru"
          SIGNUPS_ALLOWED: "true"
          WEBSOCKET_ENABLED: "true"
        volumes:
          - ./vw-data:/data
        networks:
          - shared-network

    networks:
      shared-network:
        external: true
    ```

    ---

    # 🌐 Nginx Proxy Manager

    ## docker-compose.yml

    ```yaml
    services:
      npm:
        image: jc21/nginx-proxy-manager:latest
        restart: unless-stopped
        ports:
          - "80:80"
          - "443:443"
          - "81:81"
        volumes:
          - ./data:/data
          - ./letsencrypt:/etc/letsencrypt
        networks:
          shared-network:
            ipv4_address: 172.18.0.2

    networks:
      shared-network:
        external: false
        driver: bridge
        ipam:
          config:
            - subnet: 172.18.0.0/16
              gateway: 172.18.0.1
    ```

    ---

    # ⚡ FastAPI service (fapi)

    ## docker-compose.yml

    ```yaml
    services:
      fastapi:
        build: .
        container_name: fastapi-app
        environment:
          API_KEY: "REDACTED"
          CLIENT_ID: "REDACTED"
          CLIENT_SECRET: "REDACTED"
          PASSWORD: "REDACTED"
          SERVER_URL: "https://vault.itkvadrat.ru"
        extra_hosts:
          - "vault.itkvadrat.ru:172.18.0.2"
        restart: unless-stopped
        networks:
          - shared-network

    networks:
      shared-network:
        external: true
    ```

    ---

    ## 🐳 Dockerfile

    ```dockerfile
    FROM python:3.12-slim

    RUN apt-get update && apt-get install -y \
        curl \
        gnupg \
        nodejs \
        npm \
        && rm -rf /var/lib/apt/lists/*

    RUN npm install -g @bitwarden/cli

    WORKDIR /app

    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    COPY . .

    EXPOSE 8001

    CMD ["uvicorn", "fapi:app", "--host", "0.0.0.0", "--port", "8001"]
    ```

    ---

    ## 📦 requirements.txt

    ```text
    fastapi==0.115.0
    uvicorn==0.30.0
    requests==2.32.0
    ```

    ---

    ## 🧠 fapi.py (FastAPI logic)

    ```python
    import os
    import json
    import subprocess
    import platform
    from fastapi import FastAPI, Header, HTTPException

    API_KEY = os.getenv("API_KEY")
    CLIENT_ID = os.getenv("CLIENT_ID")
    CLIENT_SECRET = os.getenv("CLIENT_SECRET")
    PASSWORD = os.getenv("PASSWORD")
    SERVER_URL = os.getenv("SERVER_URL")

    app = FastAPI(title="Vault API")


    class BitwardenCLI:
        def __init__(self):
            self.path = self._find_bw()

        def _find_bw(self):
            candidates = ["bw", "/usr/local/bin/bw", "/opt/homebrew/bin/bw"]

            for c in candidates:
                if os.path.exists(c):
                    return c

            result = subprocess.run(["bw", "--version"], capture_output=True, text=True)
            if result.returncode == 0:
                return "bw"

            raise RuntimeError("Bitwarden CLI not found")

        def run(self, args, input_data=None, env=None):
            result = subprocess.run(
                [self.path] + args,
                input=input_data,
                text=True,
                capture_output=True,
                env=env or os.environ.copy(),
            )

            if result.returncode != 0:
                raise RuntimeError(result.stderr.strip())

            return result.stdout.strip()

        def set_server(self, url):
            return self.run(["config", "server", url])

        def login_api_key(self, client_id, client_secret):
            env = os.environ.copy()
            env["BW_CLIENTID"] = client_id
            env["BW_CLIENTSECRET"] = client_secret
            return self.run(["login", "--apikey"], env=env)

        def unlock(self, password):
            return self.run(["unlock", "--raw"], input_data=password)

        def sync(self, session):
            return self.run(["sync", "--session", session])

        def list_items(self, session):
            raw = self.run(["list", "items", "--session", session])
            return json.loads(raw)

        def logout(self):
            return self.run(["logout"])


    bw = BitwardenCLI()
    SESSION = None
    CACHE = []


    def init():
        global SESSION, CACHE

        try:
            bw.logout()
        except:
            pass

        bw.set_server(SERVER_URL)
        bw.login_api_key(CLIENT_ID, CLIENT_SECRET)

        SESSION = bw.unlock(PASSWORD)

        bw.sync(SESSION)
        CACHE = bw.list_items(SESSION)

        print(f"Loaded {len(CACHE)} items")


    def check_auth(x_api_key):
        if x_api_key != API_KEY:
            raise HTTPException(401, "Unauthorized")


    @app.on_event("startup")
    def startup():
        init()


    @app.get("/items")
    def items(x_api_key: str | None = Header(None)):
        check_auth(x_api_key)
        return CACHE


    @app.get("/search/{name}")
    def search(name: str, x_api_key: str | None = Header(None)):
        check_auth(x_api_key)
        return [
            i for i in CACHE
            if name.lower() in (i.get("name") or "").lower()
        ]


    @app.get("/secret/{name}")
    def secret(name: str, x_api_key: str | None = Header(None)):
        check_auth(x_api_key)

        for item in CACHE:
            if item.get("name") == name:
                return {
                    "name": name,
                    "username": item.get("login", {}).get("username"),
                    "password": item.get("login", {}).get("password"),
                }

        raise HTTPException(404, "Not found")
    ```

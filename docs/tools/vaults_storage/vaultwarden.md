# 🔐 Vaultwarden + Caddy + API + CI/CD

[Настройка DNS](../../basics/DNS.md)

---

??? tip "🐳 Docker Compose (Vaultwarden + Caddy)"
    ### 🐳 Docker Compose
    ```yaml
    services:
      vaultwarden:
        image: vaultwarden/server:latest
        container_name: vaultwarden
        restart: always
        environment:
          DOMAIN: "https://DOMAIN" # ПОМЕНЯТЬ
          SIGNUPS_ALLOWED: "true"
        volumes:
          - ./vw-data:/data
        networks:
          - internal

      caddy:
        image: caddy:2
        container_name: caddy
        restart: always
        ports:
          - "80:80"
          - "443:443"
        volumes:
          - ./Caddyfile:/etc/caddy/Caddyfile
          - ./caddy-data:/data
        environment:
          DOMAIN: "https://DOMAIN" # ПОМЕНЯТЬ
          EMAIL: "your@email.com"
        networks:
          - internal

    networks:
      internal:
    ```

---

??? tip "🌐 Caddyfile (HTTPS + Reverse Proxy)"
    ### 🌐 Caddyfile
    ```caddy
    test.itkvadrat.ru {
        tls your@email.com

        encode gzip zstd

        header {
            Strict-Transport-Security "max-age=31536000;"
            X-Content-Type-Options "nosniff"
        }

        reverse_proxy vaultwarden:80 {
            header_up X-Real-IP {remote_host}
        }
    }
    ```

---

??? tip "🌐 Создание первых секретов и получение API KEY"
    ### 👀 UI 
    1. Зарегистрируй пользователя (если включён `SIGNUPS_ALLOWED=true`)

    2. Войди в систему

    3. Создай первую запись:
       - ➕ Add Item
       - Type: Login
       - Name: `my_secret`
       - Username: `user`
       - Password: `super-secret-password`
    
    ### 🔐 Создание API ключа

    1. Перейди:
       **Settings → Security → Keys**

    2. Нажми:
       **View API Key**

    3. Скопируй:
       - Client ID
       - Client Secret

    👉 Они понадобятся для CLI и CI/CD

---

??? tip "🐍 Python: получение паролей через CLI"
    ### 🐍 Python-1
    !ТРЕБУЕТСЯ УСТАНОВИТЬ bitwarden cli!
    npm install -g @bitwarden/cli

    ```python
    SERVER_URL = "" #######!!!!!!!!!!!
    EMAIL = "" #######!!!!!!!!!!!
    PASSWORD = "" #######!!!!!!!!!!!

    import json
    import os
    import platform
    import subprocess
    from typing import Optional, List


    class BitwardenCLI:
        def __init__(self):
            self.path = self._find_bw()

        # ---------------------------
        # FIND CLI (cross-platform)
        # ---------------------------
        def _find_bw(self) -> str:
            candidates = []

            system = platform.system().lower()

            if system == "windows":
                candidates += [
                    r"C:\Users\%USERNAME%\AppData\Roaming\npm\bw.cmd",
                    r"C:\Program Files\nodejs\bw.cmd",
                    "bw.cmd",
                ]
            else:
                candidates += [
                    "bw",
                    "/usr/local/bin/bw",
                    "/opt/homebrew/bin/bw",
                ]

            for c in candidates:
                c = os.path.expandvars(c)
                if os.path.exists(c):
                    return c

            # fallback: PATH
            result = subprocess.run(["bw", "--version"], capture_output=True, text=True)
            if result.returncode == 0:
                return "bw"

            raise RuntimeError("❌ Bitwarden CLI (bw) не найден")

        # ---------------------------
        # CORE RUNNER
        # ---------------------------
        def run(self, args: List[str], input_data: Optional[str] = None) -> str:
            cmd = [self.path] + args

            result = subprocess.run(cmd, input=input_data, text=True, capture_output=True)

            if result.returncode != 0:
                raise RuntimeError(f"CLI error: {result.stderr.strip()}")

            return result.stdout.strip()

        # ---------------------------
        # API METHODS
        # ---------------------------
        def set_server(self, url: str):
            return self.run(["config", "server", url])

        def login_api(self):
            return self.run(["login", "--apikey"])

        def login_password(self, email: str, password: str):
            return subprocess.run(
                [self.path, "login", email], input=password, text=True, capture_output=True
            )

        def unlock(self, password: str) -> str:
            return self.run(["unlock", "--raw"], input_data=password)

        def sync(self, session: str):
            return self.run(["sync", "--session", session])

        def list_items(self, session: str):
            raw = self.run(["list", "items", "--session", session])
            return json.loads(raw)

        def logout(self):
            return self.run(["logout"])

    bw = BitwardenCLI()

    try:
        bw.logout()
    except:
        pass
    
    bw.set_server(SERVER_URL)
    bw.login_password(EMAIL, PASSWORD)

    session = bw.unlock(PASSWORD)

    bw.sync(session)

    items = bw.list_items(session)

    for item in items:
        name = item.get("name")
        login = item.get("login", {})

        print(name, login.get("username"), login.get("password"))

    bw.logout()
    ```

---

??? tip "🐍 Python: получение паролей через CLI"
    ### 🐍 Python-2
    !ТРЕБУЕТСЯ УСТАНОВИТЬ bitwarden cli!
    npm install -g @bitwarden/cli

    ```python
    PASSWORD = "" #######!!!!!!!!!!!
    CLIENT_ID = ""  #######!!!!!!!!!!!
    CLIENT_SECRET = ""  #######!!!!!!!!!!!
    SERVER_URL = "" #######!!!!!!!!!!!

    import json
    import os
    import platform
    import subprocess
    from typing import Optional, List


    class BitwardenCLI:
        def __init__(self):
            self.path = self._find_bw()

        # ---------------------------
        # FIND CLI (cross-platform)
        # ---------------------------
        def _find_bw(self) -> str:
            candidates = []

            system = platform.system().lower()

            if system == "windows":
                candidates += [
                    r"C:\Users\%USERNAME%\AppData\Roaming\npm\bw.cmd",
                    r"C:\Program Files\nodejs\bw.cmd",
                    "bw.cmd",
                ]
            else:
                candidates += [
                    "bw",
                    "/usr/local/bin/bw",
                    "/opt/homebrew/bin/bw",
                ]

            for c in candidates:
                c = os.path.expandvars(c)
                if os.path.exists(c):
                    return c

            # fallback: PATH
            result = subprocess.run(["bw", "--version"], capture_output=True, text=True)
            if result.returncode == 0:
                return "bw"

            raise RuntimeError("❌ Bitwarden CLI (bw) не найден")

        # ---------------------------
        # CORE RUNNER
        # ---------------------------
        def run(self, args: List[str], input_data: Optional[str] = None) -> str:
            cmd = [self.path] + args

            result = subprocess.run(cmd, input=input_data, text=True, capture_output=True)

            if result.returncode != 0:
                raise RuntimeError(f"CLI error: {result.stderr.strip()}")

            return result.stdout.strip()
        
        # ---------------------------
        # API METHODS
        # ---------------------------
        def set_server(self, url: str):
            return self.run(["config", "server", url])

        def login_api(self):
            return self.run(["login", "--apikey"])

        def login_password(self, email: str, password: str):
            return subprocess.run(
                [self.path, "login", email], input=password, text=True, capture_output=True
            )

        def unlock(self, password: str) -> str:
            return self.run(["unlock", "--raw"], input_data=password)

        def sync(self, session: str):
            return self.run(["sync", "--session", session])

        def list_items(self, session: str):
            raw = self.run(["list", "items", "--session", session])
            return json.loads(raw)

        def logout(self):
            return self.run(["logout"])
        

        def login_api_key(self, client_id: str, client_secret: str):
            env = os.environ.copy()
            env["BW_CLIENTID"] = client_id
            env["BW_CLIENTSECRET"] = client_secret

            result = subprocess.run(
                [self.path, "login", "--apikey"],
                env=env,
                text=True,
                capture_output=True
            )

            if result.returncode != 0:
                raise RuntimeError(f"Login failed:\n{result.stderr}\n{result.stdout}")

            return result.stdout
        
    bw = BitwardenCLI()

    try:
        bw.logout()
    except:
        pass
    bw.set_server(SERVER_URL)

    bw.login_api_key(CLIENT_ID, CLIENT_SECRET)

    session = bw.unlock(PASSWORD)

    bw.sync(session)

    items = bw.list_items(session)

    for item in items:
        name = item.get("name")
        login = item.get("login", {})

        print(name, login.get("username"), login.get("password"))

    bw.logout()
    ```

---
??? tip "FastAPI Vault"
    ### Получение секретов по API
    import os
    import json
    import subprocess
    import platform
    from fastapi import FastAPI, Header, HTTPException

    # =========================
    # CONFIG
    # =========================

    API_KEY = "MY_FASTAPI_KEY" #######!!!!!!!!!!!
    CLIENT_ID = "" #######!!!!!!!!!!!
    CLIENT_SECRET = "" #######!!!!!!!!!!!
    PASSWORD = "" #######!!!!!!!!!!!
    SERVER_URL = "" #######!!!!!!!!!!!

    app = FastAPI(title="Vault API")


    # =========================
    # BITWARDEN CLI WRAPPER
    # =========================
    class BitwardenCLI:
        def __init__(self):
            self.path = self._find_bw()

        def _find_bw(self) -> str:
            candidates = []

            system = platform.system().lower()

            if system == "windows":
                candidates += [
                    os.path.expandvars(r"%APPDATA%\npm\bw.cmd"),
                    r"C:\Program Files\nodejs\bw.cmd",
                    "bw.cmd",
                ]
            else:
                candidates += [
                    "bw",
                    "/usr/local/bin/bw",
                    "/opt/homebrew/bin/bw",
                ]

            for c in candidates:
                if os.path.exists(c):
                    return c

            # fallback
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

        # -------------------------
        # YOUR WORKING FLOW
        # -------------------------
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

        def get_items(self, session):
            return self.list_items(session)
        
        def logout(self):
            return self.run(["logout"])


    # =========================
    # INIT CLIENT
    # =========================
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

        CACHE = bw.get_items(SESSION)

        print(f"🔐 Loaded {len(CACHE)} items")


    # =========================
    # AUTH
    # =========================
    def check_auth(x_api_key):
        if x_api_key != API_KEY:
            raise HTTPException(401, "Unauthorized")


    # =========================
    # STARTUP
    # =========================
    @app.on_event("startup")
    def startup():
        init()


    # =========================
    # API
    # =========================
    @app.get("/items")
    def items(x_api_key: str | None = Header(None)):
        check_auth(x_api_key)
        return CACHE


    @app.get("/search/{name}")
    def search(name: str, x_api_key: str | None = Header(None)):
        check_auth(x_api_key)

        results = [i for i in CACHE if name.lower() in (i.get("name") or "").lower()]

        return results


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


??? tip "⚙️ GitHub Actions (получение секрета)"
    ### Пример Github Actions (by VW Server)
    В secrets:

    VAULTWARDEN_PASSWORD = "" #######!!!!!!!!!!!
    VAULTWARDEN_CLIENT_ID = ""  #######!!!!!!!!!!!
    VAULTWARDEN_CLIENT_ID = ""  #######!!!!!!!!!!!
    VAULTWARDEN_URL = "" #######!!!!!!!!!!!

    {% raw %}
    ```yaml
    name: Test Vaultwarden with API Key

    on:
        push:
            branches: [ main, master ]
        pull_request:
            branches: [ main, master ]
        workflow_dispatch:

    jobs:
    get-secret:
        runs-on: ubuntu-latest
        steps:
        - name: Install Bitwarden CLI
            run: npm install -g @bitwarden/cli
        
        - name: Configure server
            run: bw config server ${{ secrets.VAULTWARDEN_URL }}
        
        - name: Login with API key
            run: bw login --apikey
            env:
            BW_CLIENTID: ${{ secrets.VAULTWARDEN_CLIENT_ID }}
            BW_CLIENTSECRET: ${{ secrets.VAULTWARDEN_CLIENT_SECRET }}
        
        - name: Unlock with master password
            id: unlock
            run: |
            SESSION_KEY=$(echo "${{ secrets.VAULTWARDEN_PASSWORD }}" | bw unlock --raw)
            echo "session_key=$SESSION_KEY" >> $GITHUB_OUTPUT
            echo "Unlocked successfully"
        
        - name: Get my_secret
            run: |
            export BW_SESSION=${{ steps.unlock.outputs.session_key }}
            
            # Ищем запись
            ITEM_ID=$(bw list items --search "my_secret" | jq -r '.[0].id')
            
            if [ "$ITEM_ID" != "null" ] && [ -n "$ITEM_ID" ]; then
                SECRET=$(bw get password $ITEM_ID)
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "Secret: my_secret"
                echo "Value: $SECRET"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            else
                echo "Error: my_secret not found"
                echo "Available secrets:"
                bw list items | jq -r '.[].name'
                exit 1
            fi
        
        - name: Logout
            run: bw logout
    ```
    {% endraw %}


??? tip "⚙️ GitHub Actions (получение секрета)"
    ### Пример Github Actions (by FastAPI)
    ```
    В secrets:

    API_KEY = "" #######!!!!!!!!!!!
    VAULT_API_URL = "" #######!!!!!!!!!!!

    {% raw %}
    name: Vault Secrets via FastAPI

    on:
        push:
            branches: [ main, master ]
        pull_request:
            branches: [ main, master ]
        workflow_dispatch:

    jobs:
    get-secret:
        runs-on: ubuntu-latest

        steps:
        - name: Install tools
            run: sudo apt-get update && sudo apt-get install -y curl jq

        # =========================
        # CALL FASTAPI
        # =========================
        - name: Get secret from Vault API
            id: secret
            run: |
            RESPONSE=$(curl -s \
                -H "X-API-Key: ${{ secrets.VAULT_API_KEY }}" \
                "${{ secrets.VAULT_API_URL }}/secret/test")

            echo "Raw response: $RESPONSE"

            LOGIN=$(echo "$RESPONSE" | jq -r '.username')
            PASSWORD=$(echo "$RESPONSE" | jq -r '.password')

            echo "LOGIN=$LOGIN" >> $GITHUB_ENV
            echo "PASSWORD=$PASSWORD" >> $GITHUB_ENV

        # =========================
        # USE SECRET
        # =========================
        - name: Print (demo)
            run: |
            echo "LOGIN is: $LOGIN"
            echo "PASSWORD is: $PASSWORD"
    {% endraw %}
    ```
    


---

??? warning "❗ Важно"

    - Отключи `SIGNUPS_ALLOWED` после регистрации
    - Используй сложный master password
    - Делай бэкапы `vw-data`
    - Не храни секреты в коде
    - Ограничь доступ к серверу (firewall / VPN)

---
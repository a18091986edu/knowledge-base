# 🌐 Сеть и порты (networking)

---

??? tip "🔌 Просмотр портов"

    ### 🔌 Открытые порты
    ```bash
    ss -tuln
    ss -tulnp                 # с процессами
    ```

---

??? tip "📦 Кто слушает порт"

    ### 📦 Кто слушает порт
    ```bash
    lsof -i :80
    ss -tulnp | grep 80
    ```

---

??? tip "🌍 Проверка подключения"

    ### 🌍 Проверка сети
    ```bash
    ping google.com
    curl ifconfig.me          # внешний IP
    ```

---

??? tip "🔍 Проверка портов извне"

    ### 🔍 Проверка доступности
    ```bash
    nc -zv IP 80
    curl http://IP
    ```

---

??? tip "🧭 IP адреса"

    ### 🧭 Сетевые интерфейсы
    ```bash
    ip a
    ip addr show
    ```

---

??? tip "🛣️ Маршруты"

    ### 🛣️ Routing
    ```bash
    ip r
    ip route
    ```

---

??? tip "🔗 Проверка DNS"

    ### 🔗 DNS
    ```bash
    nslookup google.com
    dig google.com
    ```

---

??? tip "🚀 Нет интернета"

    ```bash
    ping 8.8.8.8        # есть ли сеть
    ping google.com     # работает ли DNS
    ```

---

??? tip "⚠️ Порт не доступен"

    ```bash
    ss -tuln
    ufw status
    systemctl status nginx
    ```

---

## 🧠 Чеклист

??? tip "🧠 Алгоритм"

    1. Есть ли IP (ip a)
    2. Есть ли маршрут (ip r)
    3. Работает ли DNS
    4. Открыт ли порт
    5. Запущен ли сервис
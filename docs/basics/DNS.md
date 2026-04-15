# 🌐 Привязка субдомена к IP + проверка

??? tip "⚙️ Привязка"
    ### Привязка

    В панели управления DNS добавь запись:

    ```
    Type: A
    Name: test
    Value: IP
    TTL: Auto (или 300)
    ```

    📌 Результат:
    ```
    test.xxxxxxxx.ru → IP
    ```
    DNS обновляется не мгновенно:

    - Обычно: 1–5 минут
    - Иногда: до 24 часов (редко)


---

---

??? tip "🔍 Проверка"
    ### Проверка
    ```bash
    nslookup test.xxxxxx.ru


    Name:    test.xxx.ru
    Address: IP
    ```
    ```bash
    dig test.itkvadrat.ru +short
    dig test.itkvadrat.ru
    
    IP

    dig NS itkvadrat.ru +short
    ```
    
    ```bash
    проверка HTTPS
    curl -I https://test.itkvadrat.ru
    
    Ожидаешь:
    HTTP/2 200
    ```

---

??? tip "🧹 Очистка DNS кэша"
    ### Очистка кэша DNS
    Linux:
    ```bash
    sudo systemd-resolve --flush-caches
    ```

    Windows:
    ```bash
    ipconfig /flushdns
    ```

---

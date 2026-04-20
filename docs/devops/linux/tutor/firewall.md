# Фаервол

Примеры на **UFW** (Ubuntu). На других дистрибутивах используют **firewalld**, **nftables** или «голый» **iptables** — принципы те же: политика по умолчанию, явные разрешения, логирование.

??? tip "🟢 UFW (базовое управление)"
    ### 🟢 UFW (базовое управление)

    UFW (Uncomplicated Firewall) — простой интерфейс для управления firewall.

    ```bash
    sudo ufw enable
    sudo ufw disable

    sudo ufw status
    sudo ufw status verbose
    ```

    📌 Используется для:
    - быстрого старта
    - базовой защиты сервера


??? tip "🚪 Управление портами (UFW)"
    ### 🚪 Управление портами (UFW)

    Разрешение и запрет портов:

    ```bash
    sudo ufw allow 22
    sudo ufw allow 80/tcp
    sudo ufw allow 443

    sudo ufw deny 23
    ```

    📌 Можно указывать:
    - порт
    - протокол (tcp/udp)
    - сервис (ssh, http)


??? tip "🧹 Управление правилами (UFW)"
    ### 🧹 Управление правилами (UFW)

    Работа с правилами:

    ```bash
    sudo ufw delete allow 22
    sudo ufw reset
    ```

    📌 reset:
    - удаляет ВСЕ правила
    - отключает firewall


??? tip "🔒 Расширенные правила (UFW)"
    ### 🔒 Расширенные правила (UFW)

    Ограничения и фильтрация:

    ```bash
    sudo ufw limit ssh
    sudo ufw allow from 192.168.1.10
    sudo ufw allow from 192.168.1.0/24 to any port 22
    ```

    📌 limit:
    - защита от brute-force


??? tip "🔥 iptables (основы)"
    ### 🔥 iptables (основы)

    iptables — низкоуровневый firewall Linux.

    Основные цепочки:

    - INPUT → входящий трафик
    - OUTPUT → исходящий
    - FORWARD → транзитный

    Просмотр правил:

    ```bash
    iptables -L
    iptables -L -n -v
    iptables -L -nv --line-numbers
    ```


??? tip "🚪 Правила доступа (iptables)"
    ### 🚪 Правила доступа (iptables)

    Разрешение портов:

    ```bash
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    ```

    📌 -A:
    - добавляет правило в конец цепочки

    📌 Добавление в начало:

    ```bash
    iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
    ```


??? tip "❌ Блокировка и политики"
    ### ❌ Блокировка и политики

    Блокировка трафика:

    ```bash
    iptables -A INPUT -j DROP
    ```

    Политики по умолчанию:

    ```bash
    iptables -P INPUT DROP
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD DROP
    ```

    📌 Политика:
    - применяется, если правило не сработало


??? tip "🧹 Управление правилами (iptables)"
    ### 🧹 Управление правилами (iptables)

    Очистка:

    ```bash
    iptables -F
    iptables -F INPUT
    ```

    Удаление:

    ```bash
    iptables -D INPUT 4
    ```

    📌 Удаление по номеру:
    - сначала посмотреть `--line-numbers`


??? tip "📊 Логирование (iptables)"
    ### 📊 Логирование (iptables)

    Логирование трафика:

    ```bash
    iptables -A INPUT -j LOG
    iptables -A OUTPUT -j LOG
    iptables -A FORWARD -j LOG
    ```

    📌 Используется для:
    - анализа атак
    - отладки сети


??? tip "🌐 Фильтрация по IP и портам"
    ### 🌐 Фильтрация по IP и портам

    Работа с IP:

    ```bash
    iptables -A INPUT -s 192.168.0.104 -j DROP
    iptables -A INPUT -s 192.168.0.107 -j ACCEPT
    ```

    Блокировка исходящего трафика:

    ```bash
    iptables -A OUTPUT -p tcp --dport 80 -j REJECT
    ```


??? tip "⚙️ Сохранение правил"
    ### ⚙️ Сохранение правил

    iptables не сохраняет правила автоматически.

    Установка:

    ```bash
    sudo apt install iptables-persistent
    ```

    Сохранение:

    ```bash
    sudo netfilter-persistent save
    ```

    Восстановление:

    ```bash
    sudo netfilter-persistent reload
    ```


??? tip "🆕 nftables"
    ### 🆕 nftables

    nftables — современная замена iptables.

    ```bash
    sudo nft list ruleset
    sudo systemctl status nftables
    ```

    📌 Преимущества:
    - проще синтаксис
    - лучше производительность


??? tip "🔄 Сравнение firewall"
    ### 🔄 Сравнение firewall

    - UFW → простой frontend
    - iptables → гибкость и контроль
    - nftables → современный стандарт

    📌 Когда использовать:

    - UFW → быстрый старт
    - iptables → legacy / тонкая настройка
    - nftables → production


??? tip "🚀 Практика (базовая настройка)"
    ### 🚀 Практика (базовая настройка)

    Минимальный firewall:

    ```bash
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    sudo ufw allow ssh
    sudo ufw allow 80
    sudo ufw allow 443

    sudo ufw enable
    ```


??? tip "🔐 Безопасный сервер"
    ### 🔐 Безопасный сервер

    Усиление безопасности:

    ```bash
    sudo ufw limit ssh
    sudo ufw allow from YOUR_IP to any port 22
    sudo ufw deny 23
    ```

    📌 Практика:
    - deny by default
    - открывать только нужные порты


??? tip "🔍 Troubleshooting"
    ### 🔍 Troubleshooting

    Проверка:

    ```bash
    sudo ufw status
    ss -tuln
    ```

    📌 Проверить:

    - открыт ли порт
    - слушает ли сервис


??? tip "🧠 Чеклист диагностики"
    ### 🧠 Чеклист диагностики

    Алгоритм:

    1. Проверить firewall
    2. Проверить порт (ss)
    3. Проверить сервис (systemctl)
    4. Проверить bind (0.0.0.0 / 127.0.0.1)
    5. Проверить сеть (nc / curl)


??? tip "🚀 Best practices"
    ### 🚀 Best practices

    - всегда сначала открыть SSH
    - использовать deny по умолчанию
    - не открывать внутренние порты
    - включать логирование

    ```bash
    sudo ufw logging on
    ```
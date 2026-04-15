
# ⚙️ systemd и systemctl

??? tip "⚙️ systemd и systemctl"
    ### ⚙️ systemd и systemctl

    systemd — это система инициализации Linux, которая управляет:

    - сервисами (nginx, ssh, docker)
    - запуском системы
    - процессами в фоне
    - логами через journald

    systemctl — основной инструмент управления systemd.

    📌 Основная идея:

    ```text
    сервис = unit
    systemd = менеджер всех unit'ов
    ```


??? tip "▶️ Управление сервисами"
    ### ▶️ Управление сервисами

    Управление жизненным циклом сервиса:

    ```bash
    systemctl start nginx
    systemctl stop nginx
    systemctl restart nginx
    systemctl reload nginx
    ```

    📌 Разница restart vs reload:

    - restart → полный перезапуск процесса
    - reload → перечитать конфигурацию без остановки (если поддерживается)


??? tip "📊 Состояние и автозапуск"
    ### 📊 Состояние и автозапуск

    Проверка состояния сервиса:

    ```bash
    systemctl status nginx
    systemctl is-active nginx
    systemctl is-enabled nginx
    ```

    📌 Что означают состояния:

    - active → работает
    - inactive → остановлен
    - failed → ошибка запуска

    📌 Автозапуск:

    ```bash
    systemctl enable nginx
    systemctl disable nginx
    ```

    - enable → запуск при старте системы
    - disable → отключить автозапуск


??? tip "📜 Логи systemd (journald)"
    ### 📜 Логи systemd (journald)

    journald — централизованная система логирования systemd.

    📌 Основной просмотр:

    ```bash
    journalctl
    journalctl -u nginx
    ```

    📌 Логи привязаны к:

    - сервису
    - времени
    - уровню ошибки


??? tip "🔍 Фильтрация логов"
    ### 🔍 Фильтрация логов

    Фильтрация помогает быстро находить проблемы:

    ```bash
    journalctl -u nginx -n 50
    journalctl -u nginx -f
    journalctl --since "1 hour ago"
    journalctl -p err
    ```

    📌 Используется для:

    - отладки сервисов
    - анализа падений
    - поиска ошибок


??? tip "⚙️ Unit-файлы (конфигурация сервисов)"
    ### ⚙️ Unit-файлы (конфигурация сервисов)

    Unit-файл описывает, как systemd запускает сервис.

    📌 Расположение:

    ```bash
    /etc/systemd/system/myapp.service
    ```

    📌 Основные секции:

    ```ini
    [Unit]
    Description=My App
    After=network.target

    [Service]
    ExecStart=/usr/bin/node app.js
    Restart=always
    RestartSec=3

    [Install]
    WantedBy=multi-user.target
    ```

    📌 Секции:

    - Unit → описание и зависимости
    - Service → как запускать
    - Install → как включать автозапуск


??? tip "🔄 Применение изменений systemd"
    ### 🔄 Применение изменений systemd

    После изменения unit-файлов systemd нужно обновить конфигурацию:

    ```bash
    systemctl daemon-reload
    systemctl daemon-reexec
    systemctl restart myapp
    ```

    📌 Разница:

    - daemon-reload → перечитать unit-файлы
    - daemon-reexec → перезапуск самого systemd


??? tip "🚀 Практический workflow"
    ### 🚀 Практический workflow

    Типичный сценарий работы:

    ```bash
    systemctl status nginx
    journalctl -u nginx -n 50
    systemctl restart nginx
    ```

    📌 Используется для:

    - проверки сервиса
    - диагностики
    - быстрого рестарта


??? tip "⚠️ Диагностика проблем"
    ### ⚠️ Диагностика проблем

    Если сервис не запускается:

    ```bash
    systemctl status myapp
    journalctl -xe
    ```

    📌 Что проверять:

    - ошибки конфигурации
    - права доступа
    - отсутствующие файлы
    - порты


??? tip "🧠 Полезные команды systemd"
    ### 🧠 Полезные команды systemd

    Дополнительные инструменты диагностики:

    ```bash
    systemctl list-units --type=service
    systemctl list-unit-files
    systemctl show nginx
    systemctl kill nginx
    ```

    📌 Используется для:

    - анализа системы
    - поиска сервисов
    - диагностики состояния
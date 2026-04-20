# systemd: сервисы, журнал, загрузка

**systemd** — обычно PID 1: юниты сервисов, цели (`multi-user.target`, `graphical.target`), **journald** для логов.

---

## Идея и жизненный цикл сервиса

??? tip "Модель"
    ```text
    сервис = unit-файл
    systemctl управляет запуском, остановкой, автозагрузкой
    ```

??? tip "start, stop, restart, reload"
    ```bash
    sudo systemctl start nginx
    sudo systemctl stop nginx
    sudo systemctl restart nginx
    sudo systemctl reload nginx
    ```

    **restart** — новый процесс; **reload** — перечитать конфиг без полного обрыва (если сервис поддерживает).

??? tip "Статус и автозапуск"
    ```bash
    systemctl status nginx
    systemctl is-active nginx
    systemctl is-enabled nginx
    sudo systemctl enable nginx
    sudo systemctl disable nginx
    ```

    Состояния: **active** / **inactive** / **failed**; **enabled** / **disabled**.

---

## Журнал (journald)

??? tip "journalctl"
    ```bash
    journalctl
    journalctl -u nginx
    journalctl -u nginx -n 50
    journalctl -u nginx -f
    journalctl --since "1 hour ago"
    journalctl -p err
    journalctl -b -p err..alert
    ```

??? tip "Логи прошлых загрузок"
    ```bash
    journalctl --list-boots
    sudo journalctl -b -1
    ```

---

## Загрузка системы

??? tip "UEFI или BIOS, GRUB"
    ```bash
    [ -d /sys/firmware/efi ] && echo UEFI || echo "Legacy BIOS / ВМ без EFI"
    ls -la /boot
    ```

    - **`/boot/grub/grub.cfg`** — сгенерированный итог (не правят вручную).
    - **`/etc/default/grub`** — параметры; после правок на Debian/Ubuntu: `sudo update-grub`.

??? tip "Цепочка загрузки"
    1. Прошивка UEFI/BIOS  
    2. Загрузчик (часто GRUB)  
    3. Ядро + initramfs  
    4. **systemd**  
    5. Службы  
    6. Вход пользователя (TTY или GUI)

    ```mermaid
    flowchart LR
      A[UEFI/BIOS] --> B[GRUB]
      B --> C[Ядро + initramfs]
      C --> D[systemd]
      D --> E[Службы]
      E --> F[Вход]
    ```

    ```bash
    systemd-analyze
    systemd-analyze blame | head -20
    ```

---

## Unit-файлы и применение правок

??? tip "Пример unit"
    Путь: `/etc/systemd/system/myapp.service`

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

    После правок:

    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart myapp
    ```

    `daemon-reexec` — редкий перезапуск самого systemd.

---

## Диагностика

??? tip "Сервис не стартует"
    ```bash
    systemctl status имя_сервиса
    journalctl -u имя_сервиса -n 80 --no-pager
    journalctl -xe
    ```

    Проверь: конфиг, права, файлы, занятость порта (`ss -tlnp`).

??? tip "Обзор системы"
    ```bash
    systemctl list-units --type=service
    systemctl list-unit-files
    systemctl --failed
    systemctl show nginx
    ```

---

## Когда «всё упало» (порядок действий)

1. `uptime`, `free -h`, `df -h`, `df -hi`  
2. `journalctl -b -p err..alert` или `dmesg -T | tail`  
3. `ip a`, `ss -tlnp`  
4. `systemctl --failed`

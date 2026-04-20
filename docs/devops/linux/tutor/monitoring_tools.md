# Мониторинг: процессы, память, нагрузка

Наблюдение за CPU, RAM, диском и процессами. Управление сервисами (`systemctl`) — в разделе **Управление сервисами**.

---

## Процессы в реальном времени

??? tip "top"
    Показывает **load average**, использование CPU (user/system/iowait), память, swap, список процессов (PID, USER, %CPU, %MEM, COMMAND).

    ```bash
    top -o %CPU
    top -o %MEM
    top -u root
    ```

??? tip "htop"
    Интерактивно: дерево процессов, сортировки, поиск, **F9** — сигнал процессу. Установка: `apt install htop`.

    ```bash
    htop
    ```

---

## Снимок процессов и завершение

??? tip "ps и дерево"
    ```bash
    ps
    ps aux
    ps aux | grep nginx
    ps -eo pid,ppid,user,cmd --sort=-%mem | head
    pstree -p
    ```

??? tip "Состояния процесса"
    | Код | Смысл |
    |-----|--------|
    | R | выполняется / в очереди |
    | S | ожидает событие (sleep) |
    | T | остановлен сигналом |
    | Z | zombie: завершился, родитель не сделал `wait` |

    **Интерактивные** — привязаны к терминалу; **фоновые** — `команда &`, `jobs`; **демоны** — долгоживущие службы (часто systemd).

??? tip "kill и pidof"
    Сигналы: **15 (SIGTERM)** — корректно; **9 (SIGKILL)** — жёстко, без очистки.

    ```bash
    kill PID
    kill -9 PID
    pidof nginx
    ```

---

## Память

??? tip "free и /proc/meminfo"
    ```bash
    free -h
    ```

    Смотри на **available**: часть RAM занята кэшем, но ядро может отдать её приложениям; **free** обманчиво мало.

    ```bash
    grep -E "^MemTotal|^MemAvailable|^MemFree|^SwapTotal|^SwapFree" /proc/meminfo
    ```

    !!! warning "Регистр"
        В `/proc/meminfo` только **`MemTotal`**, **`MemAvailable`** и т.д. (не `Memtotal`).

---

## Диск и подсистема ввода-вывода

??? tip "iostat, iotop, vmstat"
    Пакет **sysstat**: `apt install sysstat`. **iotop** часто требует root.

    ```bash
    iostat -xz 1
    sudo iotop -o
    vmstat 1
    ```

---

## Приоритеты CPU и I/O

??? tip "nice, renice, ionice"
    ```bash
    nice -n 10 долгая_команда
    renice +5 -p PID
    ionice -c2 -n7 -p PID
    ```

    **stress** и **fio** — синтетическая нагрузка для тестов; на проде только осознанно.

---

## Быстрый чеклист «что тормозит»

1. `uptime`, `free -h`, `df -h`, `df -hi`
2. `top` или `htop`
3. При подозрении на диск: `iostat` / `iotop`
4. Подробнее о сбоях сервисов: `journalctl`, `systemctl` — следующий урок.

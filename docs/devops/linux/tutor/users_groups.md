# Пользователи и группы

Создание учёток, членство в группах, `sudo`, файлы `/etc/passwd`, `/etc/group`, `/etc/shadow`.

---

## Создание и удаление пользователей

??? tip "useradd / adduser"
    ```bash
    useradd user
    useradd -m user
    adduser user              # Ubuntu: интерактивно, home + пароль

    passwd user
    userdel user
    userdel -r user           # с home
    ```

    `useradd` — низкоуровнево; `adduser` — удобная обёртка.

---

## Группы

??? tip "Членство"
    ```bash
    groupadd group
    addgroup group
    groupdel group

    usermod -aG group user    # добавить в группу
    deluser user group        # Debian: убрать из группы

    groups user
    ```

    ⚠️ `usermod -G` без `-a` **перезапишет** все группы.

---

## Переключение и sudo

??? tip "su и sudo"
    ```bash
    su user
    su - user
    sudo команда
    sudo -i
    usermod -aG sudo user
    ```

    После смены групп — перелогинься.

??? tip "sudoers"
    ```bash
    sudo visudo
    ```

    Пример строки: `user ALL=(ALL:ALL) ALL`

---

## usermod и блокировка

??? tip "usermod"
    ```bash
    usermod -L user            # заблокировать
    usermod -U user            # разблокировать
    usermod -d /home/new user
    usermod -s /bin/bash user
    ```

---

## UID, активные сессии

??? tip "id, who"
    ```bash
    id user
    whoami
    users
    who
    w
    ```

    Обычно: UID **0** — root; **1–999** — системные; **1000+** — обычные пользователи.

---

## Файлы учётных данных и getent

??? tip "passwd, group, shadow"
    ```text
    /etc/passwd   — логин, UID, GID, home, shell (пароль — поле x)
    /etc/group    — группы и состав
    /etc/shadow   — хэши и политика паролей (только root)
    ```

    Просмотр одной записи без `grep` по всему файлу:

    ```bash
    getent passwd имя
    getent group sudo
    ```

    Пароли не хранят в world-readable `passwd`; реальные данные — в **`/etc/shadow`**.

---

## Практика

??? tip "Типовой серверный пользователь"
    ```bash
    adduser deploy
    usermod -aG sudo deploy
    id deploy
    su - deploy
    sudo whoami
    ```

??? tip "SSH-ключи"
    ```bash
    useradd -m -s /bin/bash deploy
    passwd deploy
    usermod -aG sudo deploy
    mkdir -p /home/deploy/.ssh
    # вставить ключ в authorized_keys
    chown -R deploy:deploy /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chmod 600 /home/deploy/.ssh/authorized_keys
    ```

---

## Связь с другими уроками

- Команды `whoami`, `which`, `file` — также в **Терминал**.
- Права на `~/.ssh` — **Права доступа**.

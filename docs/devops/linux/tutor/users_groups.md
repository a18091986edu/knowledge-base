# 👥 Управление пользователями и группами

---

## 👤 Пользователи

??? tip "👤 Создание и удаление пользователей"

    ### 👤 Создание и удаление пользователей
    ```bash
    useradd user              # создать пользователя
    useradd -m user           # создать с домашней папкой

    adduser user              # интерактивное создание (Ubuntu)

    passwd user               # задать/изменить пароль

    userdel user              # удалить пользователя
    userdel -r user           # удалить с домашней папкой
    ```

    📌 Разница:
    - `useradd` — низкоуровневая команда
    - `adduser` — удобная обёртка (создаёт home, задаёт пароль)

---

## 👥 Группы

??? tip "👥 Группы и членство"

    ### 👥 Группы и членство
    ```bash
    groupadd group
    addgroup group            # аналог (Ubuntu)

    groupdel group

    usermod -aG group user    # добавить в группу
    deluser user group        # удалить из группы

    groups user               # список групп
    ```

    ⚠️ Важно:
    ```bash
    usermod -G group user     # ❌ перезапишет группы
    usermod -aG group user    # ✅ добавит
    ```

---

## 🔄 Переключение и sudo

??? tip "🔄 Переключение пользователей"

    ### 🔄 Переключение пользователей
    ```bash
    su user
    su - user                 # с окружением
    ```

---

??? tip "🛡️ sudo"

    ### 🛡️ sudo
    ```bash
    sudo command
    sudo -i
    sudo su
    ```

    ```bash
    usermod -aG sudo user
    ```

    📌 После изменения групп → перелогиниться

---

## ⚙️ Управление пользователем

??? tip "⚙️ usermod"

    ### ⚙️ Управление пользователем (usermod)
    ```bash
    usermod -L user
    usermod -U user

    usermod -d /home/new user
    usermod -s /bin/bash user
    ```

    🔒 Блокировка:
    - в `/etc/shadow` перед паролем появляется `!`

---

## 🆔 Идентификаторы и активность

??? tip "🆔 UID, GID и пользователи"

    ### 🆔 UID, GID и активные пользователи
    ```bash
    id user
    whoami

    users
    who
    w
    ```

    📌 Типы пользователей:
    - 0 → root
    - 1–999 → системные
    - 1000+ → обычные

---

## 📁 Системные файлы

??? tip "📁 Основные файлы"

    ### 📁 Системные файлы
    ```bash
    cat /etc/passwd
    cat /etc/group
    sudo cat /etc/shadow
    ```

    📄 `/etc/passwd`:
    ```text
    user:x:UID:GID:comment:/home/user:/bin/bash
    ```

    📄 `/etc/group`:
    ```text
    group:x:GID:user1,user2
    ```

    🔒 `/etc/shadow`:
    - хранит хэши паролей
    - доступен только root

---

## 🛡️ sudoers

??? tip "🛡️ Настройка sudo"

    ### 🛡️ sudoers
    ```bash
    visudo
    ```

    📄 `/etc/sudoers`:
    ```text
    user ALL=(ALL:ALL) ALL
    ```

    Где:
    - кто → откуда → как → какие команды

---

## ⚙️ Дополнительно

??? tip "⚙️ Дополнительные параметры"

    ### ⚙️ Дополнительно
    ```bash
    useradd -D

    useradd -g group user
    useradd -G g1,g2 user
    ```

---

## 🚀 Практика

??? tip "🚀 Типичный workflow (сервер)"

    ### 🚀 Типичный workflow
    ```bash
    # 1. Создать пользователя
    adduser deploy

    # 2. Дать sudo права
    usermod -aG sudo deploy

    # 3. Проверить
    id deploy

    # 4. Переключиться
    su - deploy

    # 5. Проверить sudo
    sudo whoami
    ```

---

??? tip "🔐 Best practice (production)"

    ### 🔐 Усиленный вариант
    ```bash
    useradd -m -s /bin/bash deploy

    passwd deploy

    usermod -aG sudo deploy

    mkdir /home/deploy/.ssh
    nano /home/deploy/.ssh/authorized_keys

    chown -R deploy:deploy /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chmod 600 /home/deploy/.ssh/authorized_keys
    ```
# 🔐 Права доступа и управление доступом

---

## 📊 Просмотр и понимание прав

??? tip "📊 Просмотр прав"

    ### 📊 Просмотр прав
    ```bash
    ls -l        # показать права, владельца, группу, размер, дату
    ll           # alias для ls -l (если настроен)
    ```

    Пример:
    ```text
    -rwxr-xr-- 1 user group 1234 Apr 12 file
    ```

    Расшифровка:
    - `-` → файл (`d` — директория)
    - `rwx` → права владельца
    - `r-x` → права группы
    - `r--` → права остальных

    📌 Для директорий:
    - `r` → просмотр содержимого
    - `w` → создание/удаление файлов
    - `x` → вход в директорию

---

## ✏️ Изменение прав (chmod)

??? tip "✏️ chmod (символьный режим)"

    ### ✏️ chmod (символьный режим)
    ```bash
    chmod +x file
    chmod o+w file
    chmod go-rw file

    chmod g+w,o+r file

    chmod u=rwx,g=rw,o=r file
    chmod a=rw file
    ```

    📌 Обозначения:
    - `u` — владелец
    - `g` — группа
    - `o` — остальные
    - `a` — все

---

??? tip "🔢 chmod (числовой режим)"

    ### 🔢 chmod (числовой режим)
    ```bash
    chmod 644 file
    chmod 755 file
    chmod 640 file
    chmod 765 dir

    chmod -R 765 dir
    ```

    📌 Значения:
    - 4 → read (r)
    - 2 → write (w)
    - 1 → execute (x)

---

## 👤 Владение файлами

??? tip "👤 Владелец и группа"

    ### 👤 Владелец и группа
    ```bash
    chown user file
    chown user:group file
    chown :group file

    chown -R user dir
    ```

    ```bash
    chgrp group file
    ```

---

## 🔑 Специальные биты

??? tip "🔑 Специальные биты"

    ### 🔑 Специальные биты

    #### SUID
    ```bash
    chmod u+s file
    ```

    #### SGID
    ```bash
    chmod g+s dir
    ```

    #### Sticky bit
    ```bash
    chmod +t dir
    ```

    📌 Пример:
    ```bash
    ls -ld /tmp
    ```

---

??? tip "🔍 s и S"

    ### 🔍 s и S
    - `s` → есть execute
    - `S` → нет execute

    ```text
    -rwsr-xr-x
    -rwSr--r--
    ```

---

## ⚙️ Права по умолчанию (umask)

??? tip "⚙️ umask"

    ### ⚙️ umask
    ```bash
    umask
    umask 022
    ```

    📌 Принцип расчёта:
    ```text
    файл: 666 - umask
    папка: 777 - umask
    ```

    📊 Пример:
    ```bash
    umask 022
    ```

    ```text
    файл: 666 - 022 = 644 → rw-r--r--
    папка: 777 - 022 = 755 → rwxr-xr-x
    ```

    📊 Частые значения:
    ```text
    umask 022 → 644 / 755
    umask 002 → 664 / 775
    umask 077 → 600 / 700
    ```

    ⚠️ Важно:
    ```bash
    umask 000
    ```

    ```text
    файл всё равно будет: 666 (rw-rw-rw-)
    ```

---

??? tip "📍 Где задаётся umask"

    ### 📍 Где задаётся umask
    ```bash
    ~/.bashrc
    ~/.profile

    /etc/profile
    /etc/bash.bashrc
    ```

    📌 Применяется только к новым файлам и папкам

---

## 🔐 Расширенные права (ACL)

??? tip "🔐 ACL (расширенные права)"

    ### 🔐 ACL (расширенные права)
    ```bash
    sudo apt install acl
    ```

    ```bash
    getfacl file
    ```

    ```bash
    setfacl -m u:user:rwx file
    setfacl -m g:group:rw file

    setfacl -x u:user file
    ```

---

??? tip "📁 ACL для директорий"

    ### 📁 ACL для директорий
    ```bash
    setfacl -m u:user:rwx dir
    setfacl -d -m u:user:rwx dir
    ```

    📌 Права по умолчанию для новых файлов

---

## 🚀 Практика

??? tip "🚀 Типичный workflow"

    ### 🚀 Типичный workflow
    ```bash
    touch file
    chmod 660 file
    chown user:group file

    ls -l file
    ```

---

??? tip "🔐 Практика (проект)"

    ### 🔐 Практика (проект)
    ```bash
    mkdir project
    chown user:dev project

    chmod 775 project
    chmod g+s project

    setfacl -m u:other:r-x project
    ```
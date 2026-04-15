## 📁 Файловая структура Linux

---

## 📁 Основные каталоги

??? tip "📁 Основные каталоги"

    ### 📁 Структура
    ```bash
    /bin        # базовые команды (ls, cp, mv)
    /sbin       # системные утилиты

    /boot       # загрузка системы

    /dev        # устройства
    /etc        # конфиги

    /home       # пользователи
    /root       # root

    /lib        # библиотеки
    /usr        # программы

    /var        # логи
    /run        # runtime

    /tmp        # временные файлы

    /mnt        # ручное монтирование
    /media      # авто-монтирование

    /opt        # сторонние приложения

    /proc       # процессы (виртуальная ФС)
    /srv        # данные сервисов

    /lost+found # восстановленные файлы
    ```

---

## 💾 Работа с дисками

??? tip "💾 Использование диска"

    ### 💾 Диски
    ```bash
    df -hT
    df -hT /

    df -i            # inode usage
    df -hT -i
    ```

---

## 🧠 Inodes и ссылки

---

??? tip "🧠 Что такое inode"
    ### 🧠 Inode (как это работает)
    ```text
    [ filename ] → [ inode ] → [ data blocks ]
    ```
    📌 Важно:
    - имя файла хранится в директории
    - inode хранит метаданные и указатели на данные
    - один inode → один набор данных

---

??? tip "🔍 Проверка inode"
    ### 🔍 Проверка
    ```bash
    ls -li
    ```
    ```text
    123456 -rw-r--r-- file.txt
    ```
    📌 `123456` → inode

---

??? tip "⚠️ Проблема inode"
    ### ⚠️ Закончились inode
    ```bash
    df -i
    ```
    📌 Симптом:
    - места много, но нельзя создать файл

---

??? tip "🔗 Типы ссылок"
    ### 🔗 Виды ссылок
    - hard link
    - symbolic link (symlink)

---

??? tip "🔨 Создание ссылок"
    ### 🔨 Команды
    ```bash
    ln file link
    ln -s file link
    ```

---

??? tip "🔗 Hard link (жёсткая ссылка)"
    ### 🔗 Как работает hard link
    ```text
    file1 ─┐
           ├──→ [ inode 123 ] → [ data ]
    file2 ─┘
    ```
    📌 Важно:
    - один inode
    - это один и тот же файл
    - удаление одного имени не удаляет данные

---

??? tip "🔗 Soft link (symbolic link)"
    ### 🔗 Как работает symlink
    ```text
    link → "file" → [ inode 123 ] → [ data ]
    ```
    📌 Важно:
    - ссылка хранит путь
    - отдельный inode
    - ломается при удалении файла

---

??? tip "🔍 Hard vs Soft link"
    ### 🔍 Разница
    #### Hard link
    ```text
    file1 → inode ← file2
    ```
    - один inode
    - нельзя между файловыми системами

    #### Soft link
    ```text
    link → path → file
    ```
    - отдельный inode
    - зависит от пути

---

??? tip "📊 Проверка ссылок"
    ### 📊 Как отличить
    ```bash
    ls -li
    ```
    📌 Hard link:
    - одинаковый inode

    ```bash
    ls -l
    ```
    📌 Soft link:
    ```text
    link -> file
    ```

---

??? tip "📦 Ссылка vs копия"
    ### 📦 Разница

    #### Копия
    ```bash
    cp file copy
    ```
    ```text
    file → inode1 → data
    copy → inode2 → data
    ```

    #### Hard link
    ```bash
    ln file link
    ```
    ```text
    file1 → inode ← file2
    ```

    #### Soft link
    ```bash
    ln -s file link
    ```
    ```text
    link → file
    ```

---


## 📦 Размер файлов и папок

??? tip "📦 Анализ размера"

    ### 📦 Размер
    ```bash
    du -h
    du -hs

    du -h --max-depth=1
    ```

---

## 📁 Архивация

??? tip "📁 Архивация и сжатие"

    ### 📦 tar
    ```bash
    tar -czf file.tar.gz file
    tar -xvf file.tar.gz
    tar -xvf file.tar.gz -C /dir

    tar -tf file.tar.gz
    ```

    ### 🗜️ gzip
    ```bash
    gzip file
    gunzip file.gz

    gzip -k file
    ```

    ### 🗜️ zip
    ```bash
    sudo apt install zip unzip

    zip archive.zip file
    zip -r archive.zip dir

    unzip archive.zip
    unzip archive.zip -d /dir
    ```
## 🐧 Основы работы в терминале

---
??? tip "⌨️ Основы работы в терминале"

    ### ⌨️ Горячие клавиши терминала
    ```bash
    Ctrl + U    # очистить текущую строку
    Ctrl + R    # поиск по истории команд
    Ctrl + D    # завершение ввода (EOF)
    Ctrl + C    # прервать выполнение команды
    Ctrl + L    # очистить экран

    reset       # восстановить терминал при сбоях
    clear       # очистить экран
    ```

    ### 📚 Справочные команды
    ```bash
    whatis ls       # краткое описание команды
    man ls          # подробная документация
    help cd         # builtin-команды shell
    info ls         # расширенная документация

    apropos copy    # поиск по описанию
    man -k network  # аналог apropos
    ```

    ### 🕘 История команд
    ```bash
    history         # показать историю
    history 20      # последние 20 команд

    !10             # выполнить 10-ю команду
    !-3             # выполнить команду 3 назад
    !!              # повторить последнюю команду

    Ctrl + R        # поиск по истории
    history -c      # очистить историю
    ```

---

## 📁 Работа с файлами и папками

---
??? tip "📁 Файлы и директории"

    ### 📍 Навигация
    ```bash
    pwd             # текущая директория

    cd              # перейти в home
    cd ~            # home
    cd -            # предыдущая директория
    cd /            # корень
    cd ..           # вверх на уровень
    ```

    ### 📂 Просмотр содержимого
    ```bash
    ls              # список файлов
    ls -a           # включая скрытые
    ls -la          # подробный список
    ls -lh          # удобные размеры
    ls -R           # рекурсивно
    ```

    ### 📦 Создание
    ```bash
    mkdir dir                   # создать папку
    mkdir -p dir1/dir2/dir3    # вложенные папки

    touch file.txt             # создать файл
    touch file{1..5}.txt       # несколько файлов
    ```

    ### 📝 Запись в файл
    ```bash
    echo "Hello" > file.txt        # перезапись
    echo "World" >> file.txt       # добавление

    printf "line1\nline2\n" > file.txt

    cat > file.txt                # ввод вручную
    Ctrl + D

    cat file1 file2 > result.txt  # объединение файлов
    ```

    ### 📋 Копирование
    ```bash
    cp file1 file2            # копировать файл
    cp file /tmp/             # в директорию

    cp f* /tmp/               # по шаблону
    cp -r dir1 dir2           # папку

    cp -i file1 file2         # с подтверждением
    ```

    ### 🚚 Перемещение
    ```bash
    mv file1 file2            # переименовать
    mv file /tmp/             # переместить

    mv f* /tmp/               # по шаблону
    mv dir1 dir2              # папку
    ```

    ### ❌ Удаление
    ```bash
    rm file.txt               # удалить файл
    rm -r dir                 # удалить папку

    rm -f file.txt            # без подтверждения
    rm -rf dir                # ⚠️ опасно
    ```

    ### 🌳 Структура
    ```bash
    tree                      # структура каталогов
    tree -L 2                 # глубина 2
    ```

---

## 📖 Просмотр файлов

---
??? tip "📖 Просмотр файлов"

    ### 🔍 less (рекомендуется)
    ```bash
    less file.txt

    less -N file.txt          # номера строк
    less -i file.txt          # игнор регистра
    less +/text file.txt      # поиск при открытии
    ```

    ### 📄 more
    ```bash
    more file.txt
    more -10 file.txt
    more +100 file.txt
    ```

    ### 🔝 head / tail
    ```bash
    head file.txt
    head -10 file.txt
    head -c 100 file.txt

    tail file.txt
    tail -f file.txt          # просмотр логов
    ```

---

## 🔍 Поиск файлов

---
??? tip "🔍 find"

    ```bash
    find . -name "file.txt"
    find . -iname "file*"         # без регистра

    find . -type f                # файлы
    find . -type d                # папки

    find /dir -maxdepth 1
    find / -maxdepth 2 -type f -name "*as*"

    find . -size +10M             # >10MB
    ```

---




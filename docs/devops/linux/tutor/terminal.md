# Терминал: оболочка, файлы, поиск

Один вход в Linux для ежедневной работы: клавиши, история, навигация, просмотр, `find`/`grep`, сведения о системе и типах файлов.

---

## Горячие клавиши и справка

??? tip "Клавиши и восстановление"
    ```bash
    Ctrl+U      # очистить строку
    Ctrl+R      # поиск по истории
    Ctrl+D      # EOF / выйти из ввода
    Ctrl+C      # прервать команду
    Ctrl+L      # очистить экран
    reset       # «починить» терминал после мусора в выводе
    clear       # только экран
    ```

??? tip "Документация к командам"
    ```bash
    whatis ls
    man ls
    help cd           # встроенные команды bash
    info ls
    apropos copy
    man -k network
    ```

---

## История команд

??? tip "history, !!, !$"
    ```bash
    history
    history 20
    !10               # выполнить 10-ю команду из истории
    !-3
    !!                # повторить последнюю
    !$                # последний аргумент предыдущей команды
    sudo !!           # повторить последнюю с sudo
    history -c        # очистить (осторожно)
    ```

    Файл: `~/.bash_history`. Размер задают `HISTSIZE`, `HISTFILESIZE`, опция `histappend` в `~/.bashrc`.

---

## Навигация и операции с файлами

??? tip "Каталоги и список"
    ```bash
    pwd
    cd
    cd ~
    cd -
    cd ..
    cd /

    ls
    ls -a
    ls -la
    ls -lh
    ls -lh -d */      # только подкаталоги текущей папки
    ls -R
    ```

??? tip "Создание, копирование, перемещение, удаление"
    ```bash
    mkdir dir
    mkdir -p a/b/c
    touch f.txt
    touch file{1..5}.txt

    cp a b
    cp -r dir1 dir2
    cp -i a b

    mv a b
    mv dir1 dir2

    rm f
    rm -r dir
    rm -rf dir        # ⚠️ безвозвратно
    ```

??? tip "Вывод в файл и конкатенация"
    ```bash
    echo "x" > file
    echo "y" >> file
    printf "a\nb\n" > file
    cat > file        # ввод до Ctrl+D
    cat a b > out
    ```

??? tip "Дерево каталогов"
    ```bash
    tree
    tree -L 2
    ```

---

## Просмотр файлов

??? tip "less, more, head, tail"
    ```bash
    less file
    less -N file
    less -i file
    less +/шаблон file

    more file
    more -10 file

    head file
    head -n 20 file
    tail file
    tail -f file      # лог в реальном времени
    ```

---

## Поиск файлов (`find`)

??? tip "find"
    ```bash
    find . -name "file.txt"
    find . -iname 'file*'
    find . -type f
    find . -type d
    find /var -maxdepth 2 -type d
    find . -size +10M
    find /home -type f -size +100M
    find /tmp -type f -mtime -1      # изменялись за сутки
    ```

---

## Поиск текста (`grep`)

??? tip "grep"
    ```bash
    grep шаблон file
    grep -E 'a|b' file
    grep -r listen /etc/nginx/
    grep ERROR app.log
    ```

    В связке с другими командами: `journalctl -b | grep -i fail` (подробнее о журнале — в разделе про systemd).

---

## Система и тип файла

??? tip "uname"
    ```bash
    uname -a          # ядро, хост, архитектура
    uname -r          # версия ядра
    uname -m          # x86_64, aarch64, …
    ```

??? tip "Кто я, где команда, что за файл"
    ```bash
    whoami
    who
    w
    id
    which python3
    whereis ls
    type cd           # builtin или внешняя команда
    file /bin/ls
    stat путь_к_файлу
    ```

    Для учётных записей и `/etc/passwd` удобнее `getent` — см. раздел **Пользователи и группы**.

---

## Связанные разделы

- Права на файлы (`chmod`/`chown`) — **Права доступа**.
- Перенаправления и `|` — **Потоки и обработка данных**.
- Диски, FHS, ссылки — **Файловая система**.

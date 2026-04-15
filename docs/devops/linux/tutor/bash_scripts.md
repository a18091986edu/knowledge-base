# 🧠 Bash-скрипты

??? tip "📌 Основы скрипта"
    ### 📌 Основы скрипта

    Bash-скрипт — это файл с командами, которые выполняются последовательно.

    📌 Шебанг (shebang):

    ```bash
    #!/bin/bash
    ```

    📌 Что это значит:
    - указывает интерпретатор
    - система понимает, чем запускать файл

    📌 Пример:

    ```bash
    #!/bin/bash
    echo "Hello, world"
    ```


??? tip "📦 Переменные"
    ### 📦 Переменные

    Объявление:

    ```bash
    name="Alex"
    age=25
    ```

    Использование:

    ```bash
    echo $name
    echo "Name: $name"
    ```

    📌 Важно:
    - без пробелов вокруг `=`
    - доступ через `$`

    📌 Системные переменные:

    ```bash
    echo $HOME
    echo $USER
    echo $PATH
    echo $PWD
    ```

    📌 Специальные переменные:

    ```bash
    echo $0   # имя скрипта
    echo $1   # первый аргумент
    echo $#   # количество аргументов
    echo $?   # код последней команды
    echo $$   # PID скрипта
    ```


??? tip "⚙️ Выполнение команд"
    ### ⚙️ Выполнение команд

    Команды выполняются как в терминале:

    ```bash
    ls -l
    pwd
    date
    ```

    📌 Сохранение результата:

    ```bash
    result=$(date)
    echo $result
    ```

    📌 Старый стиль:

    ```bash
    result=`date`
    ```


??? tip "🔀 Условия (if)"
    ### 🔀 Условия (if)

    Базовый синтаксис:

    ```bash
    if [ condition ]; then
        command
    fi
    ```

    С ветвлением:

    ```bash
    if [ $age -gt 18 ]; then
        echo "Adult"
    else
        echo "Minor"
    fi
    ```

    📌 Операторы:

    ```bash
    -eq   # равно
    -ne   # не равно
    -gt   # больше
    -lt   # меньше
    -ge   # >=
    -le   # <=
    ```

    📌 Строки:

    ```bash
    if [ "$name" = "Alex" ]; then
        echo "Match"
    fi
    ```


??? tip "🔁 Циклы"
    ### 🔁 Циклы

    📌 for:

    ```bash
    for i in 1 2 3; do
        echo $i
    done
    ```

    ```bash
    for file in *.txt; do
        echo $file
    done
    ```

    📌 while:

    ```bash
    i=1
    while [ $i -le 5 ]; do
        echo $i
        i=$((i+1))
    done
    ```

    📌 until:

    ```bash
    i=1
    until [ $i -gt 5 ]; do
        echo $i
        i=$((i+1))
    done
    ```

    📌 Разница:
    - while → пока условие true
    - until → пока условие false


??? tip "📥 Входные параметры"
    ### 📥 Входные параметры

    Передача аргументов:

    ```bash
    ./script.sh arg1 arg2
    ```

    Использование:

    ```bash
    echo $1
    echo $2
    ```

    📌 Пример:

    ```bash
    #!/bin/bash
    echo "Hello, $1"
    ```

    📌 Перебор аргументов:

    ```bash
    for arg in "$@"; do
        echo $arg
    done
    ```


??? tip "🧠 Функции"
    ### 🧠 Функции

    Объявление:

    ```bash
    myfunc() {
        echo "Hello"
    }
    ```

    Вызов:

    ```bash
    myfunc
    ```

    📌 С аргументами:

    ```bash
    greet() {
        echo "Hello, $1"
    }

    greet Alex
    ```

    📌 Возврат значения (через echo):

    ```bash
    sum() {
        echo $(($1 + $2))
    }

    result=$(sum 2 3)
    ```


??? tip "🚀 Варианты запуска"
    ### 🚀 Варианты запуска

    📌 Через bash:

    ```bash
    bash script.sh
    ```

    📌 Как исполняемый файл:

    ```bash
    chmod +x script.sh
    ./script.sh
    ```

    📌 Через sh:

    ```bash
    sh script.sh
    ```

    📌 С аргументами:

    ```bash
    ./script.sh arg1 arg2
    ```

    📌 Через source (в текущем shell):

    ```bash
    source script.sh
    . script.sh
    ```

    📌 Разница:
    - `./script.sh` → новый shell
    - `source` → текущий shell (меняет переменные окружения)

## 🔄 Потоки и обработка данных

??? tip "🔢 Потоки ввода-вывода (stdin, stdout, stderr)"
    ### 🔢 Потоки ввода-вывода (stdin, stdout, stderr)

    В Linux каждый процесс использует три стандартных потока:

    ```text
    0 → stdin   (ввод)
    1 → stdout  (вывод)
    2 → stderr  (ошибки)
    ```

    📌 По умолчанию:

    - stdin → клавиатура
    - stdout → терминал
    - stderr → терминал


??? tip "📥 stdin (ввод данных)"
    ### 📥 stdin (ввод данных)

    stdin — поток входных данных для программы.

    ```bash
    cat
    ```

    📌 Ввод вручную:

    ```bash
    cat > file.txt
    ```

    Завершение ввода:

    ```bash
    Ctrl + D
    ```


??? tip "📤 stdout (вывод данных)"
    ### 📤 stdout (вывод данных)

    stdout — основной поток вывода команды.

    Перенаправление:

    ```bash
    echo "hello" > file.txt
    echo "world" >> file.txt
    ```

    Явное указание:

    ```bash
    command 1> file.txt
    ```


??? tip "⚠️ stderr (ошибки)"
    ### ⚠️ stderr (ошибки)

    stderr — поток ошибок.

    ```bash
    ls /notfound 2> error.log
    ```

    📌 Используется для:
    - логирования ошибок отдельно от вывода
    - анализа проблем


??? tip "🔀 Объединение потоков"
    ### 🔀 Объединение потоков

    Объединение stdout и stderr:

    ```bash
    command > all.log 2>&1
    ```

    📌 Расшифровка:

    ```text
    2>&1 → stderr направляется в stdout
    ```


??? tip "🚫 /dev/null (чёрная дыра)"
    ### 🚫 /dev/null (чёрная дыра)

    Используется для полного игнорирования вывода.

    ```bash
    command > /dev/null
    command 2> /dev/null
    command > /dev/null 2>&1
    ```

    📌 Применение:
    - подавить вывод
    - убрать ошибки
    - использовать в скриптах


??? tip "🔗 Конвейер (pipe)"
    ### 🔗 Конвейер (pipe)

    Pipe передаёт stdout одной команды в stdin другой:

    ```bash
    command1 | command2
    ```

    📌 Логика:

    ```text
    stdout → stdin
    ```


??? tip "🔗 Примеры pipe"
    ### 🔗 Примеры pipe

    Практическое использование:

    ```bash
    ps aux | grep nginx
    cat file.txt | grep error
    dmesg | less
    ```


??? tip "🧱 Цепочки команд"
    ### 🧱 Цепочки команд

    Несколько обработок подряд:

    ```bash
    cat file.txt | grep error | sort | uniq
    ```

    📌 Поток данных:

    ```text
    file → grep → sort → uniq
    ```


??? tip "📊 tee (раздвоение потока)"
    ### 📊 tee (раздвоение потока)

    tee позволяет:
    - сохранить вывод в файл
    - и показать его в терминале

    ```bash
    command | tee file.txt
    ```


??? tip "⚙️ Условные и логические связки команд"
    ### ⚙️ Условные и логические связки команд

    Linux позволяет объединять команды логически:

    ```bash
    command1 && command2
    command1 || command2
    command1 ; command2
    ```

    📌 Операторы:

    - `&&` → выполнить вторую команду, если первая успешна
    - `||` → выполнить вторую, если первая упала
    - `;` → выполнить последовательно независимо от результата

    📌 Примеры:

    ```bash
    mkdir test && cd test
    ```

    ```bash
    ping -c 1 google.com || echo "no connection"
    ```

    ```bash
    echo "start" ; echo "end"
    ```


??? tip "🧠 Условные конструкции (bash)"
    ### 🧠 Условные конструкции (bash)

    Используются в скриптах:

    ```bash
    if [ -f file.txt ]; then
        echo "exists"
    fi
    ```

    Проверки:

    ```bash
    -f file   # файл существует
    -d dir    # директория существует
    -z str    # строка пустая
    ```

    📌 Используется для:
    - автоматизации
    - проверки условий выполнения команд
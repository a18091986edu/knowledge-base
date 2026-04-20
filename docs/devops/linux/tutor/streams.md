# Потоки ввода-вывода и конвейеры

**stdin (0)**, **stdout (1)**, **stderr (2)**; перенаправления, объединение потоков, `|`, `tee`, логические операторы.

---

## Три потока

??? tip "Нумерация"
    По умолчанию в интерактивном терминале stdin — клавиатура, stdout и stderr — экран.

    ```text
    0 → stdin
    1 → stdout
    2 → stderr
    ```

---

## Перенаправление в файл

??? tip ">, >>, отдельно stderr"
    ```bash
    echo hello > file
    echo world >> file
    command 1> out.txt
    ls /нет_такого 2> errors.log
    ```

---

## Объединение stdout и stderr

??? tip "2>&1 и &>"
    ```bash
    command > all.log 2>&1
    command &> all.log
    ```

    `2>&1` — направить stderr туда же, куда stdout. В bash `&>` — краткая запись «оба потока в один файл».

---

## /dev/null

??? tip "Подавить вывод"
    ```bash
    command > /dev/null
    command 2> /dev/null
    command &> /dev/null
    ```

---

## Конвейер и tee

??? tip "pipe"
    ```bash
    command1 | command2
    ps aux | grep nginx
    dmesg | less
    cat file | grep error | sort | uniq
    ```

??? tip "tee"
    Одновременно в терминал и в файл; **`-a`** — дописать.

    ```bash
    command | tee log.txt
    command | tee -a log.txt
    ```

---

## Текстовые фильтры в конвейере

??? tip "cut, sort, uniq, wc, sed, awk"
    ```bash
    cut -d: -f1 /etc/passwd
    sort file | uniq -c | sort -nr
    wc -l file

    sed 's/foo/bar/' file
    sed '/DEBUG/d' app.log
    awk '{print $3}' data.txt
    awk '{s+=$1} END {print s}' nums.txt
    ```

---

## Логика между командами

??? tip "&& || ;"
    ```bash
    mkdir x && cd x
    ping -c1 host || echo "нет связи"
    echo a ; echo b
    ```

    - `&&` — вторая команда, если первая успешна  
    - `||` — вторая, если первая с ошибкой  
    - `;` — подряд, без условия

---

## Ввод с клавиатуры в файл

??? tip "cat и Ctrl+D"
    ```bash
    cat
    cat > file
    ```

---

## Связь с Bash

Условия `if [ -f file ]`, циклы и функции — в уроке **Bash-скрипты**.

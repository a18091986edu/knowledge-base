# Дополнительные CLI-утилиты

Не входят в «минимальный» дистрибутив: ставятся отдельно (`apt install …`). Дубли с уроками **Терминал**, **Мониторинг**, **Сеть** сведены к одному месту: здесь — компактные команды и связки.

---

## Навигация: что использовать

| Задача | Утилиты |
|--------|---------|
| Найти **файл** по имени | `fd` (или `find` в базовом курсе) |
| Найти **текст** в файлах | `rg` (ripgrep) или `grep` |
| Выбрать из списка интерактивно | `fzf` |
| Читать файл с подсветкой | `bat` |
| Список каталога «красиво» | `eza` (или `ls`) |
| Обзор дисков | `duf` или `df` / `ncdu` из мониторинга |
| HTTP / API | `curl`, опционально `httpie` |
| Проверка порта | `nc` (`netcat`) |
| Скан сети | `nmap` |
| Краткая справка вместо `man` | `tldr` |
| Умный `cd` по истории | `zoxide` |

---

## Поиск: fd, rg, fzf

??? tip "fd"
    Быстрый поиск файлов по имени (проще синтаксис, чем у `find`).

    ```bash
    fd nginx
    fd -e conf
    fd -t f
    fd -t d
    fd -H
    ```

??? tip "rg (ripgrep)"
    Поиск содержимого; по умолчанию уважает `.gitignore`.

    ```bash
    rg "error"
    rg -i "error"
    rg -n "TODO" .
    rg "ERROR" /var/log
    ```

??? tip "fzf"
    Нечёткий выбор строки из stdin.

    ```bash
    history | fzf
    fd | fzf
    ps aux | fzf
    ```

??? tip "Связка"
    ```bash
    fd | fzf | xargs bat
    rg "error" | fzf
    ```

---

## Просмотр и дерево

??? tip "bat, eza, tree"
    ```bash
    bat file.conf
    bat --style=plain file

    eza -la
    eza -T --level=2

    tree -L 2
    ```

??? tip "duf"
    ```bash
    duf
    duf -only local
    ```

---

## HTTP и загрузки

??? tip "curl"
    ```bash
    curl -I https://example.com
    curl -L URL
    curl -X POST -d "a=1" URL
    curl -H "Authorization: Bearer токен" URL
    curl -o file.zip URL
    ```

    Без `-L` редиректы могут не пройти.

??? tip "wget"
    ```bash
    wget URL
    wget -c URL
    wget -O имя.zip URL
    ```

??? tip "httpie (`http`)"
    Читаемый вывод для API (ставится отдельно).

    ```bash
    http GET https://api.example.com
    http POST https://api.example.com name=test
    ```

---

## Порты и сеть

??? tip "nc и nmap"
    ```bash
    nc -zv host 443
    nc -zv host 20-100

    nmap host
    nmap -p 80,443 host
    ```

    Расширенная диагностика интерфейсов и DNS — урок **Сеть** (`ip`, `ss`, `dig`).

---

## Мониторинг «в одном окне»

??? tip "glances, напоминание про htop"
    ```bash
    glances
    ```

    **top**, **htop**, **iotop**, **iftop**, **free**, **vmstat** — в уроке **Инструменты мониторинга**.

---

## Ускорение работы в shell

??? tip "zoxide"
    ```bash
    z имя_части_пути
    zi
    ```

??? tip "tldr"
    ```bash
    tldr tar
    tldr --update
    ```

??? tip "thefuck"
    Исправляет опечатку или добавляет `sudo` к предыдущей команде — **всегда смотри**, что предлагается.

    ```bash
    fuck
    ```

---

## SSH, копирование, синхронизация

??? tip "ssh"
    ```bash
    ssh user@host
    ssh -p 2222 user@host
    ssh -i key.pem user@host
    ssh user@host "uname -a"
    ```

??? tip "ssh-keygen и authorized_keys"
    ```bash
    ssh-keygen
    ssh-copy-id user@host
    ```

??? tip "scp"
    ```bash
    scp file user@host:/tmp/
    scp user@host:/var/log/app.log .
    scp -r dir user@host:/path
    ```

??? tip "rsync"
    Важен **слэш** у источника: `rsync -av src/ dest/` копирует **содержимое** `src`.

    ```bash
    rsync -av dir/ backup/
    rsync -avz --delete build/ user@host:/var/www/app/
    ```

---

## Документы: pandoc

??? tip "Конвертация"
    ```bash
    pandoc notes.md -o notes.html
    pandoc report.md -o report.pdf --toc
    ```

    Для PDF может понадобиться LaTeX (`texlive`).

---

## Минимальный «расширенный» набор

Привычный стек после базового курса:

`htop`, `ncdu`, `fzf`, `rg`, `bat`, `jq`, `curl`, `rsync`, `tldr`, `zoxide`

Подробнее о **`jq`** — в документации к проекту; для JSON из консоли: `curl API | jq .`

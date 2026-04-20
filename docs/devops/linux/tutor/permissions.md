# Права доступа

Модель **rwx** для **владельца (u)**, **группы (g)** и **остальных (o)**. Каталоги: `r` — список имён, `w` — создавать/удалять записи, `x` — «вход» в каталог.

---

## Просмотр

??? tip "ls -l"
    ```bash
    ls -l
    ```

    Пример: `-rwxr-xr-- 1 user group … file` — тип файла, три тройки прав, владелец, группа.

---

## chmod: символы и цифры

??? tip "Символьный режим"
    ```bash
    chmod +x file
    chmod u+x,go-w file
    chmod u=rwx,g=rw,o=r file
    chmod a=rw file
    chmod -R go-w dir
    ```

??? tip "Числовой режим"
    Сумма: r=4, w=2, x=1 → например **755** = `rwxr-xr-x`, **644** = `rw-r--r--`.

    ```bash
    chmod 644 file
    chmod 755 script.sh
    chmod -R 750 dir
    ```

---

## Владелец и группа

??? tip "chown, chgrp"
    ```bash
    chown user file
    chown user:group file
    chown :group file
    chown -R www-data:www-data /var/www
    chgrp group file
    ```

---

## SUID, SGID, sticky

??? tip "Спецбиты"
    | Бит | На файле | На каталоге |
    |-----|----------|---------------|
    | **SUID** `u+s` | процесс с правами **владельца** файла | редко |
    | **SGID** `g+s` | группа процесса = группа файла | новые файлы наследуют группу каталога |
    | **Sticky** `+t` (часто **1777**) | — | удалить чужой файл в каталоге может только владелец файла (`/tmp`) |

    ```bash
    chmod u+s binary
    chmod g+s shared_dir
    chmod +t /tmp
    ls -ld /tmp
    ```

    В `ls` буква **`s`** у `x` значит setuid/setgid **с** execute; **`S`** — бит выставлен **без** execute.

---

## umask

??? tip "Маска по умолчанию"
    ```bash
    umask
    umask 022
    ```

    Обычно права нового **файла** ≈ `666 & ~umask`, **каталога** ≈ `777 & ~umask`.

    Типично: **022** → файлы `644`, каталоги `755`; **077** → `600` / `700`.

    Задаётся в `~/.bashrc`, `~/.profile`, `/etc/profile`, `/etc/bash.bashrc`.

---

## ACL

??? tip "getfacl / setfacl"
    ```bash
    sudo apt install acl
    getfacl file
    setfacl -m u:alice:rwx file
    setfacl -m g:devs:rw file
    setfacl -x u:alice file
    ```

    Дефолтные ACL на каталог (наследование для новых файлов):

    ```bash
    setfacl -d -m u:alice:rwx dir
    ```

---

## Практика

??? tip "Файл и общий каталог"
    ```bash
    touch f
    chmod 660 f
    chown user:group f

    mkdir project
    chown user:dev project
    chmod 775 project
    chmod g+s project
    ```

---

## Связь с учебником

Базовый **`ls`** — урок **Терминал**. Пользователи и группы — **Пользователи и группы**.

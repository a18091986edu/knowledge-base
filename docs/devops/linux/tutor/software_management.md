# Управление пакетами

Акцент на **Debian/Ubuntu (APT)**. Для Fedora/RHEL смотри таблицу эквивалентов в конце.

!!! note "Дистрибутив"
    Пути к репозиториям и имена команд на других семействах отличаются.

---

## Обновление индекса и пакетов

??? tip "apt update / upgrade"
    Сначала обновляется **список** пакетов, затем сами пакеты.

    ```bash
    sudo apt update
    sudo apt upgrade
    sudo apt full-upgrade
    sudo apt upgrade --with-new-pkgs
    apt list --upgradable
    ```

    `full-upgrade` может тянуть новые зависимости — на проде в окне обслуживания.

---

## Установка и удаление

??? tip "install, remove, purge"
    ```bash
    sudo apt install nginx
    sudo apt install -y htop
    sudo apt install nginx=1.18.*

    sudo apt remove nginx
    sudo apt purge nginx
    ```

---

## Что установлено и что ставили вручную

??? tip "dpkg, apt list, apt-mark"
    Все пакеты:

    ```bash
    dpkg -l
    apt list --installed
    ```

    Только **явно** установленные вами (без авто-зависимостей):

    ```bash
    apt-mark showmanual
    apt-mark showmanual | head -20
    ```

    Фильтры:

    ```bash
    dpkg -l | grep '^ii'
    dpkg -l | grep -E '^ii\s+nginx'
    apt list --installed 2>/dev/null | grep nginx
    ```

---

## Поиск и метаданные

??? tip "search, show, policy"
    ```bash
    apt search nginx
    apt show curl
    apt-cache policy nginx
    ```

---

## Очистка

??? tip "autoremove, clean"
    ```bash
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
    ```

---

## Локальный .deb и репозитории

??? tip "dpkg -i и PPA"
    ```bash
    sudo dpkg -i файл.deb
    sudo apt -f install

    sudo add-apt-repository ppa:repo/name
    sudo apt update
    cat /etc/apt/sources.list
    ls /etc/apt/sources.list.d/
    ```

---

## Snap

??? tip "snap"
    Изолированные пакеты от Canonical; медленнее APT, но переносимее.

    ```bash
    snap install имя
    snap remove имя
    snap list
    snap refresh
    snap info имя
    ```

---

## Другие дистрибутивы

??? tip "Сопоставление команд"
    | Debian / Ubuntu | Fedora / RHEL |
    |-----------------|---------------|
    | `apt update && apt upgrade` | `dnf upgrade` |
    | `apt install` | `dnf install` |
    | `apt show` | `dnf info` |
    | `dpkg -l` | `rpm -qa` / `dnf list installed` |

    ```bash
    # Arch
    sudo pacman -Syu
    sudo pacman -S nginx
    ```

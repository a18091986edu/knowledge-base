
## 📦 Управление программным обеспечением

??? tip "🔄 Обновление пакетов"
    ### 🔄 Обновление пакетов

    Обновление системы в APT состоит из двух этапов:

    - обновление списка пакетов
    - обновление установленных пакетов

    Дополнительные команды:

    - full-upgrade → обновление с изменением зависимостей
    - upgrade --with-new-pkgs → установка новых зависимостей при апгрейде
    - list --upgradable → показать пакеты, которые можно обновить

    ```bash
    sudo apt update
    sudo apt upgrade
    sudo apt full-upgrade
    sudo apt upgrade --with-new-pkgs
    apt list --upgradable
    ```


??? tip "📥 Установка пакетов"
    ### 📥 Установка пакетов

    Установка пакетов из репозиториев APT.

    Возможности:
    - установка из официальных репозиториев
    - установка конкретной версии
    - установка без подтверждения

    ```bash
    sudo apt install nginx
    sudo apt install -y htop
    sudo apt install nginx=1.18.*
    ```


??? tip "📦 Snap пакеты"
    ### 📦 Snap пакеты

    Snap — альтернативная система пакетов от Canonical.

    Особенности:
    - изолированные (sandbox)
    - включают зависимости внутри пакета
    - работают на разных дистрибутивах
    - медленнее APT, но более универсальны

    Основные команды:

    ```bash
    snap install nginx
    snap remove nginx
    snap list
    snap refresh
    snap info nginx
    ```

    Отличие от APT:
    - APT → системные пакеты Linux
    - Snap → контейнеризированные приложения


??? tip "❌ Удаление пакетов"
    ### ❌ Удаление пакетов

    Удаление пакетов может быть:

    - remove → удаляет программу, оставляет конфиги
    - purge → удаляет полностью, включая конфигурацию

    ```bash
    sudo apt remove nginx
    sudo apt purge nginx
    ```


??? tip "📄 Список установленных пакетов"
    ### 📄 Список установленных пакетов

    Просмотр всех установленных пакетов в системе:

    ```bash
    dpkg -l
    apt list --installed
    ```

    Используется для:
    - аудита системы
    - поиска установленных пакетов
    - диагностики окружения


??? tip "🧹 Очистка системы"
    ### 🧹 Очистка системы

    Очистка ненужных пакетов и кеша:

    ```bash
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
    ```


??? tip "🔍 Поиск пакетов"
    ### 🔍 Поиск пакетов

    Поиск пакетов в репозиториях:

    ```bash
    apt search nginx
    apt list --installed
    apt list --upgradable
    ```


??? tip "📄 Информация о пакете"
    ### 📄 Информация о пакете

    Просмотр информации о пакете:

    ```bash
    apt show nginx
    apt-cache policy nginx
    ```

    Показывает:
    - версию
    - репозиторий
    - зависимости


??? tip "📦 Работа с .deb пакетами"
    ### 📦 Работа с .deb пакетами

    Установка локальных deb пакетов:

    ```bash
    sudo dpkg -i file.deb
    sudo apt -f install
    ```


??? tip "⚙️ Репозитории"
    ### ⚙️ Репозитории

    Управление источниками пакетов:

    ```bash
    add-apt-repository ppa:repo/name
    sudo apt update

    cat /etc/apt/sources.list
    ls /etc/apt/sources.list.d/
    ```


??? tip "🔄 Сравнение пакетных менеджеров"
    ### 🔄 Сравнение пакетных менеджеров

    Основные системы:

    - APT → Debian / Ubuntu
    - DNF → Fedora / RHEL (новый стандарт)
    - YUM → устаревший RHEL/CentOS
    - PACMAN → Arch Linux

    ```bash
    # APT
    sudo apt update && sudo apt upgrade

    # DNF
    sudo dnf upgrade

    # YUM
    sudo yum update

    # PACMAN
    sudo pacman -Syu
    ```

    Установка:

    ```bash
    sudo apt install nginx
    sudo dnf install nginx
    sudo yum install nginx
    sudo pacman -S nginx
    ```
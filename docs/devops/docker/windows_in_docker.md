[Dockur Windows Git](https://github.com/dockur/windows?tab=readme-ov-file){:target="_blank"} (конфигурации, аргументы)

стандартный логин-пароль Docker-admin


## установка на windows
```
- wsl -l -v
- если в выводе только 
    ```  NAME              STATE           VERSION
    * docker-desktop    Running         2
    ```
- установить полноценный WSL2 дистрибутив
- wsl --install -d Ubuntu-22.04
- wsl -d Ubuntu-22.04
- sudo apt update
- sudo apt install -y cpu-checker qemu-kvm
- kvm-ok
- откройте настройки Docker Desktop: кликните правой кнопкой мыши по иконке Docker в трее и выберите Settings.
- Перейдите в раздел → Resources → WSL Integration.
- Включите интеграцию для вашего дистрибутива: Убедитесь, что переключатель "Enable integration with my default WSL distro" (включить интеграцию с моим WSL-дистрибутивом по умолчанию) активен. 
- В списке ниже найдите ваш дистрибутив WINMAIN и включите для него переключатель (сделайте его синим/активным).
- Нажмите Apply & Restart (Применить и перезапустить).
- wsl -d Ubuntu-22.04
   
- docker run -it --rm --name windows -e "VERSION=11" -p 8006:8006 --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN -v "${PWD:-.}/windows:/storage" --stop-timeout 120 docker.io/dockurr/windows

или для монтирования на другой диск

# Создаем папку на диске E:
mkdir -p /mnt/e/docker/windows

# Запускаем с монтированием этой папки
docker run -it --rm --name windows \
  -e "VERSION=11" \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v "/mnt/e/docker/windows:/storage" \
  --stop-timeout 120 \
  docker.io/dockurr/windows
   
```

## установка на linux
```
docker run -d \
    --name windows \
    --device /dev/kvm \
    --cap-add NET_ADMIN \
    -p 8006:8006 \
    -p 4489:3389 \
    -p 5900:5900 \
    -e VERSION="win11" \
    -e LANGUAGE="Russian" \
    -e DISK_SIZE="64G" \
    dockurr/windows

    # 8006 - порт для доступа по http
    # 5900 - VNC
    # 4489 - RDP
```
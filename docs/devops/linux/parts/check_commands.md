    ```
    - free -h - данные о RAM
    - df -hT - данные о HDD
    - lspu - CPU
    - ps aux --sort=-%cpu | head -10 # топ 10 процессов по CPU
    - ps aux --sort=-%mem | head -10 # топ 10 процессов по RAM
    - top | htop    
    ########################## ВИДЕОКАРТА #####################
    - lspci | grep -i vga
    - lspci -v -s [01:00.0] (подставить данные из предыдуей команды)
    - sudo lshw -C display

                ############# NVIDIA ##############
    
    - sudo ubuntu-drivers autoinstall
    - sudo reboot
    - nvidia-smi

    ```
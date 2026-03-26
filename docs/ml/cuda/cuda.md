## Проверка видеокарты

???+ tip "Windows"
    ```
    Get-CimInstance Win32_VideoController | Select-Object Name (powershell)
    nvidia-smi (powershell проверка драйверов)
    ```

???+ tip "Linux"
    ```
    lspci | grep -i "vga\|3d\|display"
    sudo ubuntu-drivers autoinstall
    sudo reboot
    nvidia-smi
    ```


???+ tip "скрипт создания и проверки окружения с CUDA"
{% include "ml/cuda/parts/cuda_config.md" %}
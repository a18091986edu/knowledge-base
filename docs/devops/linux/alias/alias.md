#

???+ tip "Создание алиаса"
    <!-- {% raw %} -->
    ```bash
    mkdir -p ~/bin
    nano ~/bin/alias_file
    chmod +x ~/bin/alias_file

    echo $PATH | grep "$HOME/bin" # проверить есть ли ~/bin в PATH
    
    # если ничего не вывелось - добавить:

    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    
    ```
    <!-- {% endraw %} -->

???- tip "Красивый вывод docker ps -> docker_ ps -a | docker images -> docker_ images"
{% include "devops/linux/alias/parts/docker_ps_images.md" %}
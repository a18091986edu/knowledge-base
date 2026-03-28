    ```bash
    
    ansible -i /ansible/inventory.ini all --list-hosts # Показать все хосты из инвентаря
    ansible -i /ansible/inventory.ini web_servers --list-hosts # Показать только web_servers
    ansible -i /ansible/inventory.ini all -m command -a "uptime" # выполнить произвольную команду на всех узлах
    ansible -i /ansible/inventory.ini all -m shell -a "cat /etc/os-release | grep PRETTY_NAME" # Узнать версию ОС на всех узлах


    
    ```
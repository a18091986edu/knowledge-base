    {% raw %}
    ```bash
      ---
      - name: Demonstrate loops
        hosts: web_servers
        
        tasks:
            # Простой список
            - name: Loop over simple list
            ansible.builtin.debug:
                msg: "Package: {{ item }}"
            loop:
                - nginx
                - git
                - curl
                
            # Список словарей
            - name: Loop over list of dictionaries
            ansible.builtin.debug:
                msg: "User {{ item.name }} has UID {{ item.uid }}"
            loop:
                - { name: 'alice', uid: 1001 }
                - { name: 'bob', uid: 1002 }
                - { name: 'charlie', uid: 1003 }
                
            # Работа с JSON
            - name: Parse and iterate over JSON
            vars:
                users_json: |
                [
                    {"username": "admin", "shell": "/bin/bash", "groups": ["sudo", "adm"]},
                    {"username": "deploy", "shell": "/bin/sh", "groups": ["www-data"]},
                    {"username": "monitor", "shell": "/bin/bash", "groups": ["systemd-journal"]}
                ]
                users: "{{ users_json | from_json }}"
            ansible.builtin.debug:
                msg: "Creating user {{ item.username }} with shell {{ item.shell }}"
            loop: "{{ users }}"
            
            # Цикл с индексом
            - name: Loop with index
            ansible.builtin.debug:
                msg: "{{ index }}: {{ item }}"
            loop: "{{ ['apple', 'banana', 'orange'] }}"
            loop_control:
                index_var: index
                
            # Цикл по словарю
            - name: Loop over dictionary
            ansible.builtin.debug:
                msg: "{{ key }} = {{ value }}"
            loop: "{{ {'name': 'John', 'age': 30, 'city': 'New York'} | dict2items }}"
            loop_control:
                loop_var: item
            vars:
                key: "{{ item.key }}"
                value: "{{ item.value }}"
    ```
    {% endraw %}
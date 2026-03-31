    {% raw %}
    ```yml
      ---
      - name: Simple user creation from JSON
        hosts: web_servers
        become: yes
        vars:
            # Простой JSON с пользователями
            users_json: |
            [
                {"name": "alice", "uid": 2001, "shell": "/bin/bash", "groups": ["sudo"]},
                {"name": "bob", "uid": 2002, "shell": "/bin/bash", "groups": []},
                {"name": "charlie", "uid": 2003, "shell": "/bin/sh", "groups": ["www-data"]}
            ]
            users: "{{ users_json | from_json }}"
            
        tasks:
            # Создаем группы (только необходимые)
            - name: Create required groups
            ansible.builtin.group:
                name: "{{ item }}"
                state: present
            loop: "{{ ['sudo', 'www-data'] }}"
            
            # Создаем пользователей
            - name: Create users
            ansible.builtin.user:
                name: "{{ item.name }}"
                uid: "{{ item.uid }}"
                shell: "{{ item.shell }}"
                groups: "{{ item.groups | join(',') }}"
                append: yes
                create_home: yes
                state: present
            loop: "{{ users }}"
            
            # Проверяем созданных пользователей
            - name: Verify users
            ansible.builtin.command: "id {{ item.name }}"
            loop: "{{ users }}"
            register: user_check
            changed_when: false
            
            # Выводим результат
            - name: Display results
            ansible.builtin.debug:
                msg: |
                User: {{ item.item.name }}
                UID: {{ item.item.uid }}
                Status: {{ 'OK' if item is success else 'FAILED' }}
            loop: "{{ user_check.results }}"
            
            # Итоговый отчет
            - name: Final summary
            ansible.builtin.debug:
                msg: |
                ===================================
                USER CREATION SUMMARY
                ===================================
                Total users defined: {{ users | length }}
                Successful creations: {{ user_check.results | selectattr('failed', 'equalto', false) | list | length }}
                ===================================
            run_once: yes

    ```
    {% endraw %}
    {% raw %}
    ```bash
      ---
      - name: Demonstrate Jinja2 filters
        hosts: localhost
        gather_facts: no
        
        vars:
            # Разные типы данных для демонстрации
            numbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            words: ["apple", "banana", "cherry", "date"]
            json_string: '{"name": "John", "age": 30, "city": "New York"}'
            servers:
            - name: web01
                ip: 192.168.1.10
                role: web
            - name: web02
                ip: 192.168.1.11
                role: web
            - name: db01
                ip: 192.168.1.20
                role: database
                
        tasks:
            # Фильтры для списков
            - name: List filters
            ansible.builtin.debug:
                msg: |
                Original: {{ numbers }}
                First 3: {{ numbers[:3] }}
                Last 3: {{ numbers[-3:] }}
                Odd numbers: {{ numbers | select('odd') | list }}
                Even numbers: {{ numbers | select('even') | list }}
                Sum: {{ numbers | sum }}
                Max: {{ numbers | max }}
                Min: {{ numbers | min }}
                
            # Фильтры для строк
            - name: String filters
            ansible.builtin.debug:
                msg: |
                Uppercase: {{ "hello world" | upper }}
                Lowercase: {{ "HELLO WORLD" | lower }}
                Title: {{ "hello world" | title }}
                Replace: {{ "hello world" | replace("world", "ansible") }}
                Length: {{ "hello" | length }}
                
            # JSON фильтры
            - name: JSON filters
            ansible.builtin.debug:
                msg: |
                Original JSON: {{ json_string }}
                Parsed: {{ json_string | from_json }}
                Name: {{ (json_string | from_json).name }}
                To JSON (pretty): {{ servers | to_json(indent=2) }}
                To YAML: {{ servers | to_yaml }}
                
            # Фильтры для выборки данных
            - name: Data selection filters
            ansible.builtin.debug:
                msg: |
                Web servers only: {{ servers | selectattr('role', 'equalto', 'web') | list }}
                Server names: {{ servers | map(attribute='name') | list }}
                IP addresses: {{ servers | map(attribute='ip') | list }}
                Unique roles: {{ servers | map(attribute='role') | unique | list }}
                
            # Комбинация фильтров
            - name: Combined filters
            ansible.builtin.debug:
                msg: "Web servers: {{ servers | selectattr('role', 'equalto', 'web') | map(attribute='name') | list | join(', ') }}"
    ```
    {% endraw %}
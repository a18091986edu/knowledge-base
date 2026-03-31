    {% raw %}
    ```yml
    ---
      - name: Display system information
        hosts: web_servers
        gather_facts: yes
        
        tasks:
            - name: Show system summary
            ansible.builtin.debug:
                msg: |
                ===================================
                Host: {{ ansible_facts['hostname'] }}
                OS: {{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}
                Kernel: {{ ansible_facts['kernel'] }}
                CPU: {{ ansible_facts['processor_cores'] }} cores
                RAM: {{ ansible_facts['memtotal_mb'] }} MB
                IP: {{ ansible_facts['default_ipv4']['address'] }}
                ===================================
    ```
    {% endraw %}
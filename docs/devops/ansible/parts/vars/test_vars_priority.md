    {% raw %}
    ```yaml
    ---
    - name: Test variables priority
      hosts: web_servers
      vars:
        playbook_var: "This is from playbook"
        
      tasks:
        - name: Display all variables
          ansible.builtin.debug:
            msg: |
              ===================================
              Host: {{ ansible_facts['hostname'] }}
              ===================================
              web_port: {{ web_port | default('not defined') }}
              node_role: {{ node_role | default('not defined') }}
              custom_message: {{ custom_message | default('not defined') }}
              maintainer: {{ maintainer | default('not defined') }}
              environment: {{ environment | default('not defined') }}
              app_version: {{ app_version | default('not defined') }}
              playbook_var: {{ playbook_var }}
              ===================================
    ```
    {% endraw %}
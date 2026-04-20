    {% raw %}
    ```
    #!/bin/bash

    set -e

    BASE_DIR="$HOME/ansible"

    echo "===> Creating directory structure"

    mkdir -p "$BASE_DIR/inventory"
    mkdir -p "$BASE_DIR/group_vars"
    mkdir -p "$BASE_DIR/roles/common/tasks"
    mkdir -p "$BASE_DIR/roles/common/handlers"

    echo "===> Creating and populating files if empty"

    # -------------------------
    # inventory/hosts.ini
    # -------------------------
    INVENTORY="$BASE_DIR/inventory/hosts.ini"

    if [ ! -s "$INVENTORY" ]; then
    cat <<EOF > "$INVENTORY"
    [servers]
    # Пример:
    # server1 ansible_host=1.2.3.4 ansible_user=root
    EOF
    fi

    # -------------------------
    # group_vars/all.yml
    # -------------------------
    GROUP_VARS="$BASE_DIR/group_vars/all.yml"

    if [ ! -s "$GROUP_VARS" ]; then
    cat <<EOF > "$GROUP_VARS"
    ---
    ansible_python_interpreter: /usr/bin/python3
    docker_compose_version: v2.24.0
    EOF
    fi

    # -------------------------
    # roles/common/tasks/main.yml
    # -------------------------
    TASKS="$BASE_DIR/roles/common/tasks/main.yml"

    cat <<EOF > "$TASKS"
    - name: Update apt cache
    apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install prerequisites
    apt:
        name:
        - apt-transport-https
        - ca-certificates
        - curl
        - gnupg
        - lsb-release
        state: present

    - name: Remove old Docker packages
    apt:
        name:
        - docker
        - docker-engine
        - docker.io
        - containerd
        - runc
        state: absent

    - name: Add Docker GPG key
    apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker repository
    apt_repository:
        repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
        state: present

    - name: Install Docker Engine
    apt:
        name:
        - docker-ce
        - docker-ce-cli
        - containerd.io
        - docker-buildx-plugin
        state: present
        update_cache: yes

    - name: Install Docker Compose Plugin
    apt:
        name: docker-compose-plugin
        state: present
    register: compose_apt_result
    ignore_errors: yes

    - name: Download Docker Compose Plugin if apt install failed
    get_url:
        url: "https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-linux-x86_64"
        dest: /usr/local/lib/docker/cli-plugins/docker-compose
        mode: '0755'
    when: compose_apt_result is failed

    - name: Create Docker Compose symlink for compatibility
    file:
        src: /usr/local/lib/docker/cli-plugins/docker-compose
        dest: /usr/local/bin/docker-compose
        state: link
    when: compose_apt_result is failed

    - name: Install base packages
    apt:
        name:
        - curl
        - wget
        - git
        - htop
        - unzip
        - jq
        - make
        - python3
        - python3-pip
        - net-tools
        - ufw
        - fail2ban
        state: present

    - name: Ensure Docker service is enabled
    systemd:
        name: docker
        enabled: yes

    - name: Start Docker service
    systemd:
        name: docker
        state: started
    register: docker_start

    - name: Wait for Docker socket to be ready
    wait_for:
        path: /var/run/docker.sock
        timeout: 30
        state: present

    - name: Check if Docker socket has correct permissions
    stat:
        path: /var/run/docker.sock
    register: docker_socket

    - name: Fix Docker socket permissions if needed
    file:
        path: /var/run/docker.sock
        mode: '0666'
    when: docker_socket.stat.exists

    - name: Add user to docker group
    user:
        name: "{{ ansible_user }}"
        groups: docker
        append: yes

    - name: Test Docker connection
    command: docker ps
    register: docker_test
    changed_when: false
    retries: 3
    delay: 5
    until: docker_test is success

    - name: Show Docker status
    debug:
        msg: "✅ Docker is running and accessible"

    - name: Verify Docker Compose installation
    command: docker compose version
    register: compose_version
    changed_when: false

    - name: Show Docker Compose version
    debug:
        msg: "✅ Docker Compose version: {{ compose_version.stdout }}"

    - name: Create test container to verify everything works
    command: docker run --rm hello-world
    register: hello_test
    changed_when: false
    ignore_errors: yes

    - name: Show hello-world test result
    debug:
        msg: "✅ Docker hello-world test passed"
    when: hello_test is success

    - name: Install uv
    shell: |
        curl -Ls https://astral.sh/uv/install.sh | bash
    args:
        creates: /home/{{ ansible_user }}/.local/bin/uv

    - name: Ensure Docker daemon is configured for best performance
    copy:
        content: |
        {
            "log-driver": "json-file",
            "log-opts": {
            "max-size": "10m",
            "max-file": "3"
            },
            "storage-driver": "overlay2",
            "live-restore": true
        }
        dest: /etc/docker/daemon.json

    - name: Create docker group if it doesn't exist
    group:
        name: docker
        state: present

    - name: Ensure docker group permissions
    file:
        path: /var/run/docker.sock
        owner: root
        group: docker
        mode: '0660'

    - name: Add current user to docker group
    user:
        name: "{{ ansible_user }}"
        groups: docker
        append: yes

    - name: Final Docker verification
    command: docker info
    register: docker_info
    changed_when: false

    - name: Show Docker info summary
    debug:
        msg:
        - "✅ Docker is fully configured"
        - "Storage Driver: {{ docker_info.stdout | regex_search('Storage Driver: (.*)') | default('unknown') }}"
        - "Docker Root Dir: {{ docker_info.stdout | regex_search('Docker Root Dir: (.*)') | default('unknown') }}"
    EOF


    # -------------------------
    # playbook.yml
    # -------------------------
    PLAYBOOK="$BASE_DIR/playbook.yml"

    cat <<EOF > "$PLAYBOOK"
    - name: Bootstrap servers
    hosts: servers
    become: yes
    gather_facts: yes

    roles:
        - common

    post_tasks:
        - name: Check Docker daemon
        command: docker info
        register: final_docker_check
        changed_when: false
        failed_when: false
        
        - name: Display success message
        debug:
            msg:
            - "========================================"
            - "✅ BOOTSTRAP COMPLETED SUCCESSFULLY"
            - "========================================"
            - "Docker Engine: Installed and running"
            - "Docker Compose: Installed"
            - "User: {{ ansible_user }} is in docker group"
            - "========================================"
        when: final_docker_check.rc == 0
        
        - name: Display failure message
        debug:
            msg:
            - "========================================"
            - "⚠️ BOOTSTRAP COMPLETED WITH WARNINGS"
            - "========================================"
            - "Docker may not be fully configured"
            - "Please check manually: docker info"
            - "========================================"
        when: final_docker_check.rc != 0
    EOF


    echo "✅ Ansible project structure ready"
    echo ""
    echo "📁 Location: $BASE_DIR"
    echo ""
    echo "📋 Next steps:"
    echo "  1. Edit inventory: nano $BASE_DIR/inventory/hosts.ini"
    echo "  2. Run bootstrap: cd $BASE_DIR && ansible-playbook playbook.yml -v"
    echo ""

    ```
    {% endraw %}
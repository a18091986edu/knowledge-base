    ```
    #!/bin/bash

    set -e

    BASE_DIR="$HOME/ansible"
    KEY_PATH="$HOME/.ssh/id_ed25519"

    echo "===> Step 1: Install Ansible"

    sudo apt update
    sudo apt install -y ansible sshpass

    echo "===> Step 2: Create project structure"

    bash create_ansible_structure.sh

    echo "===> Step 3: Check SSH key"

    if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "ansible" -f "$KEY_PATH" -N ""
    else
    echo "✅ SSH key already exists"
    fi
    echo "===> Step 4: Install docker module"

    ansible-galaxy collection install community.docker

    echo "✅ Controller is ready"
    echo "👉 Next step: run ./bootstrap.sh"
    ```


    
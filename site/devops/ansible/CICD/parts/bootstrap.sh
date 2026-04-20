    ```
    #!/bin/bash

    set -e

    BASE_DIR="$HOME/ansible"
    INVENTORY="$BASE_DIR/inventory/hosts.ini"
    PLAYBOOK="$BASE_DIR/playbook.yml"
    KEY_PATH="$HOME/.ssh/id_ed25519"

    echo "===> Step 1: Check inventory file"

    if [ ! -f "$INVENTORY" ]; then
    echo "❌ Inventory file not found: $INVENTORY"
    exit 1
    fi

    echo "===> Step 2: Processing inventory..."

    grep 'ansible_host' "$INVENTORY" | while read -r line; do
        HOST=$(echo "$line" | awk '{print $1}')

        IP=$(echo "$line" | sed -n 's/.*ansible_host=\([^ ]*\).*/\1/p')
        USER=$(echo "$line" | sed -n 's/.*ansible_user=\([^ ]*\).*/\1/p')

        echo ""
        echo "-----> $HOST ($USER@$IP)"

        echo "Checking SSH access..."

        if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "echo ok" 2>/dev/null; then
            echo "✅ SSH already works"
        else
            echo "❌ SSH key auth failed"
            echo "Attempting ssh-copy-id..."

            ssh-copy-id -o StrictHostKeyChecking=no -i "$KEY_PATH.pub" "$USER@$IP" || {
                echo "⚠️ ssh-copy-id failed"
            }
        fi
    done

    echo ""
    echo "===> Step 3: Run Ansible playbook"

    ansible-playbook -i "$INVENTORY" "$PLAYBOOK"
    ```
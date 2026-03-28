    ```
    services:
    ansible-controller:
        image: alpine:latest
        container_name: ansible_controller
        command: tail -f /dev/null
        volumes:
        - ./ansible:/ansible
        working_dir: /ansible
        networks:
        - lab_network
        depends_on:
        - node1
        - node2
        - node3

    node1:
        image: ubuntu:22.04
        container_name: node1
        command: >
        sh -c "apt-get update &&
                apt-get install -y openssh-server python3 sudo &&
                mkdir -p /var/run/sshd &&
                echo 'root:password' | chpasswd &&
                sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
                sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
                service ssh start &&
                tail -f /dev/null"
        networks:
        lab_network:
            ipv4_address: 172.25.0.11

    node2:
        image: ubuntu:22.04
        container_name: node2
        command: >
        sh -c "apt-get update &&
                apt-get install -y openssh-server python3 sudo &&
                mkdir -p /var/run/sshd &&
                echo 'root:password' | chpasswd &&
                sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
                sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
                service ssh start &&
                tail -f /dev/null"
        networks:
        lab_network:
            ipv4_address: 172.25.0.12

    node3:
        image: ubuntu:22.04
        container_name: node3
        command: >
        sh -c "apt-get update &&
                apt-get install -y openssh-server python3 sudo &&
                mkdir -p /var/run/sshd &&
                echo 'root:password' | chpasswd &&
                sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
                sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
                service ssh start &&
                tail -f /dev/null"
        networks:
        lab_network:
            ipv4_address: 172.25.0.13

    networks:
    lab_network:
        driver: bridge
        ipam:
        config:
            - subnet: 172.25.0.0/24
    ```
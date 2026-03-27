    {% raw %}
    ```bash

    #!/bin/bash

    # Цвета ANSI
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    WHITE='\033[1;37m'
    GRAY='\033[0;90m'
    NC='\033[0m'

    # Функция для отображения подсказки
    show_help() {
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${WHITE}docker_ — красивая обёртка для Docker${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}Доступные команды:${NC}"
        echo -e "  ${YELLOW}docker_ ps${NC}        - показать запущенные контейнеры (красивый вывод)"
        echo -e "  ${YELLOW}docker_ ps -a${NC}     - показать все контейнеры (красивый вывод)"
        echo -e "  ${YELLOW}docker_ images${NC}    - показать образы (красивый вывод)"
        echo -e "  ${YELLOW}docker_ -h${NC}        - показать эту справку"
        echo -e "  ${YELLOW}docker_ --help${NC}    - показать эту справку"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    }

    # Функция для получения IP адреса контейнера
    get_container_ip() {
        local container_id="$1"
        local network="${2:-bridge}"
        
        local ip=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$container_id" 2>/dev/null)
        
        if [[ -z "$ip" ]]; then
            echo "-"
        else
            echo "$ip"
        fi
    }

    # Функция для определения цвета и иконки по статусу контейнера
    get_container_status_style() {
        local status="$1"

        if [[ "$status" == *"unhealthy"* ]]; then
            echo "🟡|$YELLOW"
        elif [[ "$status" == *"Up"* ]]; then
            echo "🟢|$GREEN"
        elif [[ "$status" == *"Exited"* ]]; then
            echo "🔴|$RED"
        elif [[ "$status" == *"created"* ]]; then
            echo "⚪|$GRAY"
        else
            echo "●|$WHITE"
        fi
    }

    # Функция для определения цвета и иконки для образов
    get_image_status_style() {
        local repo="$1"
        local tag="$2"

        if [[ "$repo" == "<none>" ]] || [[ "$tag" == "<none>" ]]; then
            echo "📦|$GRAY"
        else
            echo "🖼️|$BLUE"
        fi
    }

    # Функция для форматирования портов по 3 на строке
    format_ports() {
        local ports="$1"
        local indent="$2"

        [[ -z "$ports" || "$ports" == "-" ]] && echo "-" && return

        local IFS=','
        local -a port_array=($ports)
        local result=""
        local count=0
        local line=""

        for port in "${port_array[@]}"; do
            port=$(echo "$port" | xargs)

            if [[ $count -eq 0 ]]; then
                line="$port"
            else
                line="$line, $port"
            fi

            count=$((count + 1))

            if [[ $count -eq 3 || $port == "${port_array[-1]}" ]]; then
                if [[ -z "$result" ]]; then
                    result="$line"
                else
                    result="$result\n$indent$line"
                fi
                count=0
                line=""
            fi
        done

        echo -e "$result"
    }

    # Функция для форматирования тегов образа (по 2 на строке)
    format_tags() {
        local tags="$1"
        local indent="$2"

        [[ -z "$tags" || "$tags" == "-" ]] && echo "-" && return

        local IFS=','
        local -a tag_array=($tags)
        local result=""
        local count=0
        local line=""

        for tag in "${tag_array[@]}"; do
            tag=$(echo "$tag" | xargs)

            if [[ $count -eq 0 ]]; then
                line="$tag"
            else
                line="$line, $tag"
            fi

            count=$((count + 1))

            if [[ $count -eq 2 || $tag == "${tag_array[-1]}" ]]; then
                if [[ -z "$result" ]]; then
                    result="$line"
                else
                    result="$result\n$indent$line"
                fi
                count=0
                line=""
            fi
        done

        echo -e "$result"
    }

    # Функция для показа образов
    show_images() {
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        printf "%-5s %-20s %-25s %-12s %-15s\n" "" "REPOSITORY" "TAG" "SIZE" "CREATED"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

        mapfile -t lines < <(docker images --format "{{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | sort)

        for line in "${lines[@]}"; do
            IFS=$'\t' read -r repo tag size created <<< "$line"

            image_style=$(get_image_status_style "$repo" "$tag")
            icon="${image_style%%|*}"
            icon_color="${image_style##*|}"

            indent_width=5
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 20))
            indent_width=$((indent_width + 1))

            indent=$(printf "%${indent_width}s" "")
            formatted_tags=$(format_tags "$tag" "$indent")

            echo -ne "${icon_color}$(printf "%-5s" "$icon")${NC} "
            echo -ne "${WHITE}$(printf "%-20s" "$repo")${NC} "

            if [[ "$formatted_tags" == *"\n"* ]]; then
                first_line=$(echo -e "$formatted_tags" | head -n1)
                echo -ne "${BLUE}$(printf "%-25s" "$first_line")${NC} "
                echo -e "${GREEN}$(printf "%-12s" "$size")${NC} ${YELLOW}$(printf "%-15s" "$created")${NC}"

                echo -e "$formatted_tags" | tail -n +2 | while IFS= read -r tag_line; do
                    echo -e "${indent}${BLUE}$tag_line${NC}"
                done
            else
                echo -ne "${BLUE}$(printf "%-25s" "$formatted_tags")${NC} "
                echo -e "${GREEN}$(printf "%-12s" "$size")${NC} ${YELLOW}$(printf "%-15s" "$created")${NC}"
            fi
        done

        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    }

    # Функция для показа контейнеров (все или только запущенные)
    show_containers() {
        local show_all="$1"
        local docker_cmd="docker ps"

        if [[ "$show_all" == "true" ]]; then
            docker_cmd="docker ps -a"
        fi

        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        printf "%-5s %-7s %-25s %-20s %-22s %-25s %-25s\n" "" "ID" "NAME" "IP" "STATUS" "IMAGE" "PORTS"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

        mapfile -t lines < <($docker_cmd --format "{{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}")

        for line in "${lines[@]}"; do
            IFS=$'\t' read -r id name status image ports <<< "$line"

            short_id="${id:0:5}"
            container_ip=$(get_container_ip "$id")
            status_style=$(get_container_status_style "$status")
            icon="${status_style%%|*}"
            status_color="${status_style##*|}"

            indent_width=5
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 7))
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 25))
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 20))
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 22))
            indent_width=$((indent_width + 1))
            indent_width=$((indent_width + 25))
            indent_width=$((indent_width + 1))

            indent=$(printf "%${indent_width}s" "")
            formatted_ports=$(format_ports "$ports" "$indent")

            echo -ne "${status_color}$(printf "%-5s" "$icon")${NC} "
            echo -ne "${WHITE}$(printf "%-7s" "$short_id")${NC} "
            echo -ne "${WHITE}$(printf "%-25s" "$name")${NC} "
            echo -ne "${CYAN}$(printf "%-20s" "$container_ip")${NC} "
            echo -ne "${status_color}$(printf "%-22s" "$status")${NC} "
            echo -ne "${BLUE}$(printf "%-25s" "$image")${NC} "

            if [[ "$formatted_ports" == *"\n"* ]]; then
                first_line=$(echo -e "$formatted_ports" | head -n1)
                echo -e "${YELLOW}$(printf "%-25s" "$first_line")${NC}"

                echo -e "$formatted_ports" | tail -n +2 | while IFS= read -r port_line; do
                    echo -e "${indent}${YELLOW}$port_line${NC}"
                done
            else
                echo -e "${YELLOW}$(printf "%-25s" "$formatted_ports")${NC}"
            fi
        done

        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    }

    # Проверка на запрос помощи
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "help" ]]; then
        show_help
        exit 0
    fi

    # Проверка на пустые аргументы
    if [[ -z "$1" ]]; then
        echo -e "${RED}Ошибка: не указана команда${NC}"
        echo ""
        show_help
        exit 1
    fi

    # Обработка команд (только ps, ps -a, images)
    if [[ "$1" == "ps" && "$2" == "-a" ]]; then
        show_containers "true"
    elif [[ "$1" == "ps" ]]; then
        show_containers "false"
    elif [[ "$1" == "images" ]]; then
        show_images
    elif [[ "$1" == "ps" && "$2" != "" && "$2" != "-a" ]]; then
        echo -e "${RED}Ошибка: неизвестный флаг '$2' для команды ps${NC}"
        echo -e "${GREEN}Использование:${NC}"
        echo -e "  ${YELLOW}docker_ ps${NC}    - показать запущенные контейнеры"
        echo -e "  ${YELLOW}docker_ ps -a${NC} - показать все контейнеры"
        exit 1
    else
        # Любая другая команда — показываем ошибку и справку
        echo -e "${RED}Ошибка: неизвестная команда '${YELLOW}$1${RED}'${NC}"
        echo ""
        echo -e "${GREEN}docker_ поддерживает только следующие команды:${NC}"
        echo -e "  ${YELLOW}docker_ ps${NC}        - показать запущенные контейнеры"
        echo -e "  ${YELLOW}docker_ ps -a${NC}     - показать все контейнеры"
        echo -e "  ${YELLOW}docker_ images${NC}    - показать образы"
        echo ""
        echo -e "${GREEN}Справка:${NC} ${YELLOW}docker_ --help${NC}"
        exit 1
    fi
    ```

    {% endraw %}
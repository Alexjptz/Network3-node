#!/bin/bash

tput reset
tput civis

INSTALLATION_PATH="$HOME/blockmesh"

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo ""
        exit 0
}

incorrect_option () {
    echo ""
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo ""
    show_red "Invalid option. Please choose from the available options."
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_red "Ошибка (Fail)"
        echo ""
    fi
}

run_commands_info() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_blue "Не найден (Not Found)"
        echo ""
    fi
}

run_node_command() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        show_green "НОДА ЗАПУЩЕНА (NODE IS RUNNING)!"
        echo
    else
        show_red "НОДА НЕ ЗАПУЩЕНА (NODE ISN'T RUNNING)!"
        echo
    fi
}


show_orange " .__   __. .___________. __  ___  ____ " && sleep 0.2
show_orange " |  \ |  | |           ||  |/  / |___ \ " && sleep 0.2
show_orange " |   \|  |  ---|  |---- |  '  /    __) | " && sleep 0.2
show_orange " |  .    |     |  |     |    <    |__ < " && sleep 0.2
show_orange " |  |\   |     |  |     |  .  \   ___) | " && sleep 0.2
show_orange " |__| \__|     |__|     |__|\__\ |____/ " && sleep 0.2
echo
sleep 1

while true; do
    show_green "----- MAIN MENU -----"
    echo "1. Установка (Install)"
    echo "2. Логи (Logs)"
    echo "3. Запуск/Остановка (Start/Restart/Stop)"
    echo "4. Удаление (Delete)"
    echo "5. Данные ноды"
    echo "6. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            process_notification "Начинаем установку (Starting installation)..."
            echo

            # Update packages
            process_notification "Обновляем пакеты (Updating packages)..."
            run_commands "sudo apt update && sudo apt upgrade -y && apt install tar net-tools iptables"

            process_notification "Создаем папку (Creating Dir)..."
            run_commands "mkdir -p $HOME/network3 && cd $HOME/network3"

            process_notification "Скачиваем (Downloading)..."
            run_commands "wget -O ubuntu-node-latest.tar https://network3.io/ubuntu-node-v2.1.0.tar"

            process_notification "Распаковываем (Extracting)..."
            run_commands "tar -xvf ubuntu-node-latest.tar && rm ubuntu-node-latest.tar"

            echo
            show_green "----- ЗАВЕРШЕНО. COMPLETED! ------"
            echo
            ;;
        2)
            # Logs
            MY_IP=$(hostname -I | awk '{print $1}')
            process_notification "Кликните (Click) -> https://account.network3.ai/main?o=$MY_IP:8080"
            ;;
        3)
            echo
            show_orange "Выберете (Choose)"
            echo
            echo "1. Запуск (Start)"
            echo "2. Остановка (Stop)"
            echo
            read -p "Выберите опцию (Select option): " option
                case $option in
                    1)
                        # Start
                        process_notification "Запускаем (Starting)..."
                        run_node_command "cd $HOME/network3/ubuntu-node/ && ./manager.sh up"
                        echo
                        ;;
                    2)
                        process_notification "Останавливаем (Stopping)..."
                        run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
                        echo
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
                ;;
        4)
            # Delete
            process_notification "Удаляем ноду (Deleting node)"
            echo
            process_notification "Останавливаем (Stopping)..."
            run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
            echo
            process_notification "Удаляем файлы (Deleting Files)..."
            run_commands "rm -rvf $HOME/network3"
            echo
            show_green "--- НОДА УДАЛЕНА. NODE DELETED ---"
            echo
            ;;
        5)
            # node data
            process_notification "Ищем (Looking)..."
            show_green "YOUR NODE KEY"
            run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh key"
            ;;
        6)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done

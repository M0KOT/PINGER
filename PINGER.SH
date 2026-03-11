#!/bin/bash

# Функция для проверки и установки traceroute на Unix
check_and_install_traceroute() {
    if ! command -v traceroute &> /dev/null; then
        echo "traceroute не найден. Попытка установки..."
        
        # Определяем менеджер пакетов
        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            echo "Обнаружен apt-get. Устанавливаем traceroute..."
            sudo apt-get update && sudo apt-get install -y traceroute
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            echo "Обнаружен yum. Устанавливаем traceroute..."
            sudo yum install -y traceroute
        elif command -v dnf &> /dev/null; then
            # Fedora
            echo "Обнаружен dnf. Устанавливаем traceroute..."
            sudo dnf install -y traceroute
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            echo "Обнаружен pacman. Устанавливаем traceroute..."
            sudo pacman -S --noconfirm traceroute
        elif command -v zypper &> /dev/null; then
            # openSUSE
            echo "Обнаружен zypper. Устанавливаем traceroute..."
            sudo zypper install -y traceroute
        elif command -v brew &> /dev/null; then
            # macOS
            echo "Обнаружен Homebrew. Устанавливаем traceroute..."
            brew install traceroute
        elif command -v pkg &> /dev/null; then
            # FreeBSD
            echo "Обнаружен pkg. Устанавливаем traceroute..."
            sudo pkg install -y traceroute
        else
            echo "Не удалось определить менеджер пакетов."
            echo "Пожалуйста, установите traceroute вручную:"
            echo "  - Debian/Ubuntu: sudo apt-get install traceroute"
            echo "  - CentOS/RHEL: sudo yum install traceroute"
            echo "  - Fedora: sudo dnf install traceroute"
            echo "  - Arch: sudo pacman -S traceroute"
            echo "  - macOS: brew install traceroute"
            echo "  - FreeBSD: sudo pkg install traceroute"
            exit 1
        fi
        
        # Проверяем успешность установки
        if command -v traceroute &> /dev/null; then
            echo "traceroute успешно установлен!"
        else
            echo "Ошибка при установке traceroute"
            exit 1
        fi
    fi
}

if [ -n "$WINDIR" ]; then
    OS="windows"
    PING_CMD="ping -n 4"
    TRACERT_CMD="tracert"
else
    OS="unix"
    PING_CMD="ping -c 4"
    TRACERT_CMD="traceroute"
    
    echo "Проверка наличия traceroute..."
    check_and_install_traceroute
fi

clear
cloud="1.1.1.1"
Ya="77.88.8.8"

echo "################################################################################"
echo "###          ПИНГЕР - УТИЛИТА ДЛЯ ТЕХ КОМУ ВЛОМ ПИНГОВАТЬ РУЧКАМИ            ###"
echo "################################################################################"
echo "OS: $OS"
echo ""
echo "Выбери сайт для пинга: Yandex ($Ya) / Cloudflare ($cloud) / СВОЙ ДОМЕН"
echo ""

read -p "Введи YA (или 1) для Yandex, CL (или 2) для Cloudflare, или введи свой домен: " site
site=$(echo "$site" | tr -d '"' | tr -d "'")

if [ -z "$site" ]; then
    echo "Ошибка: пустой ввод"
    exit 1
fi

# Приводим к верхнему регистру
site=$(echo "$site" | tr '[:lower:]' '[:upper:]')

if [ "$site" = "YA" ] || [ "$site" = "1" ]; then
    echo ""
    echo "Пингую Yandex ($Ya)"
    $PING_CMD "$Ya"
    echo ""
    $TRACERT_CMD "$Ya"
    
elif [ "$site" = "CL" ] || [ "$site" = "2" ]; then
    echo ""
    echo "Пингую Cloudflare ($cloud)"
    $PING_CMD "$cloud"
    echo ""
    $TRACERT_CMD "$cloud"
    
else
    echo ""
    echo "Пингую свой домен: $site"
    $PING_CMD "$site"
    echo ""
    $TRACERT_CMD "$site"
fi

echo ""
read -p "Нажми Enter для выхода..."
#!/bin/bash

HOSTS=("host_1" "host_2")
AGENT_URL="http://kaspersky.server.com/dlpkg?id=******"  # URL агента
ANTIVIRUS_URL="http://kaspersky.server.com/dlpkg?id=******"  # URL антивируса
SSH_USER="root"  # Пользователь SSH
SSH_KEY="~/.ssh/id_rsa"  # Путь к SSH ключу (оставьте пустым для аутентификации по паролю)
TEMP_DIR="/tmp"

# Функция для выполнения команд по SSH
ssh_exec() {
    local host="$1"
    local cmd="$2"
    local ssh_cmd="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30"
    
    # Добавляем ключ SSH если указан
    if [ -n "$SSH_KEY" ]; then
        ssh_cmd="$ssh_cmd -i $SSH_KEY"
    fi
    
    $ssh_cmd "${SSH_USER}@$host" "$cmd"
}

# Функция для проверки существования файла
check_file_exists() {
    local host="$1"
    local file="$2"
    ssh_exec "$host" "[ -f \"$file\" ] && echo \"exists\" || echo \"not_exists\""
}

# Функция для проверки URL
check_url() {
    local url="$1"
    curl -s -o /dev/null -w "%{http_code}" -k --connect-timeout 30 "$url"
}

# Функция для вывода сообщения с временной меткой
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Основной цикл по хостам
for host in "${HOSTS[@]}"; do
    log "Обрабатываем хост: $host"
    
    # Проверяем доступность хоста
    if ! ssh_exec "$host" "echo 'Host is reachable'" &>/dev/null; then
        log "Ошибка: хост $host недоступен"
        continue
    fi
        
    # Вторая часть: установка KESL
    log "Проверяем, установлен ли KESL..."
    kesl_status=$(check_file_exists "$host" "/opt/kaspersky/kesl/bin/kesl-control")
    
    if [ "$kesl_status" = "exists" ]; then
        log "KESL уже установлен на $host. Пропускаем установку."
        continue
    fi
    
    log "Проверяем доступность URL агента..."
    url_status=$(check_url "$AGENT_URL")
    if [ "$url_status" -ne 200 ]; then
        log "Ошибка: URL агента недоступен (статус: $url_status)"
        continue
    fi

    log "Устанавливаем локаль ru_RU.UTF-8..."
    ssh_exec "$host" "sudo yum install -y glibc-langpack-ru glibc-common || sudo yum install -y glibc-common"
    ssh_exec "$host" "sudo localedef -f UTF-8 -i ru_RU ru_RU.UTF-8 || true"
    ssh_exec "$host" "sudo bash -c 'echo LANG=ru_RU.UTF-8 > /etc/locale.conf'"
    ssh_exec "$host" "sudo bash -c 'echo LC_ALL=ru_RU.UTF-8 >> /etc/locale.conf'"

    log "Устанавливаем необходимые пакеты..."
    if ! ssh_exec "$host" "sudo yum install -y wget curl perl libstdc++ glibc"; then
        log "Ошибка при установке пакетов на $host"
        continue
    fi

    
    log "Скачиваем и устанавливаем агент..."
    if ! ssh_exec "$host" "wget -O $TEMP_DIR/agent \"$AGENT_URL\" && sudo chmod 755 $TEMP_DIR/agent && sudo sh $TEMP_DIR/agent && rm -f $TEMP_DIR/agent"; then
        log "Ошибка при установке агента на $host"
        continue
    fi
    
    log "Скачиваем и устанавливаем антивирус..."
    if ! ssh_exec "$host" "wget -O $TEMP_DIR/antivirus \"$ANTIVIRUS_URL\" && sudo chmod 755 $TEMP_DIR/antivirus && sudo sh $TEMP_DIR/antivirus && rm -f $TEMP_DIR/antivirus"; then
        log "Ошибка при установке антивируса на $host"
        continue
    fi
    
    log "Установка завершена на хосте: $host"
done

log "Все операции завершены!"
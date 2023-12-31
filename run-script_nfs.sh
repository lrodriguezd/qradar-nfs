#!/bin/bash

# Ruta al archivo direcciones_ip.txt
hosts_file="direcciones_ip.txt"

# Nombre del script que deseas ejecutar en los servidores remotos
remote_script="script_nfs.sh"

# Leer el archivo direcciones_ip.txt y ejecutar el script en los host
while IFS= read -r line; do
    # Omitir las líneas que comienzan con #
    if [[ ! "$line" =~ ^\# ]]; then
        # Obtener la dirección IP y el nombre del host desde la línea
        ip_address=$(echo "$line" | awk '{print $1}')
        server_name=$(echo "$line" | awk '{print $2}')

        # Verificar si la línea no contiene localhost ni direcciones IPv6
        if [[ "$ip_address" != "::"* && "$ip_address" != "127.0.0.1" && "$ip_address" != "0.0.0.0" && ! -z "$server_name" && ! "$line" =~ primary && ! "$line" =~ secondary ]]; then
            echo "Ejecutando $remote_script en $server_name ($ip_address)..."

            # Utiliza SSH para ejecutar el script en el host
            ssh -o StrictHostKeyChecking=no "$server_name" "bash -s" < "$remote_script"

            echo "Script ejecutado en $server_name."
            echo ""
        fi
    fi
done < "$hosts_file"

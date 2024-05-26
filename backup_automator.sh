#Author: Gorka Gallardo 

#!/bin/bash

# Función para realizar la copia de seguridad
perform_backup() {
    src_dir="$1"
    dest_dir="$2"
    
    # Comprueba si la hora está especificada
    if [ -n "$3" ]; then
        backup_time="$3"
    else
        backup_time=$(date +"%Y%m%d_%H%M%S")
    fi
    
    # Crea el directorio de destino si no existe
    mkdir -p "$dest_dir"
    
    # Realiza la copia de seguridad recursiva desde el directorio fuente al destino
    cp -r "$src_dir" "$dest_dir/backup_$backup_time"
    
    echo "Copia de seguridad realizada en $dest_dir/backup_$backup_time"
}

# Menú principal
while true; do
    clear
    echo "Menú de Copia de Seguridad"
    echo "-------------------------"
    echo "1. Realizar una copia de seguridad"
    echo "2. Programar copia de seguridad recurrente"
    echo "3. Salir"
    read -p "Seleccione una opción: " choice

    case $choice in
        1)
            read -p "Ruta del directorio a copiar (recursivamente): " src_directory
            read -p "Ruta de destino para guardar la copia: " dest_directory
            read -p "Hora para hacer la copia (opcional, formato HH:MM): " backup_time
            perform_backup "$src_directory" "$dest_directory" "$backup_time"
            ;;
        2)
            read -p "Ruta del directorio a copiar (recursivamente): " src_directory
            read -p "Ruta de destino para guardar la copia: " dest_directory
            read -p "Hora para hacer la copia (opcional, formato HH:MM): " backup_time
            # Validación de la hora (debe ser en formato HH:MM)
            if [[ $backup_time =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
                # Configura la tarea cron para copias de seguridad recurrentes
                (crontab -l 2>/dev/null; echo "0 $backup_time * * * /bin/bash $PWD/backup_script.sh $src_directory $dest_directory") | crontab -
                echo "Copia de seguridad recurrente programada todos los días a las $backup_time en $dest_directory"
            else
                echo "La hora no es válida. Formato esperado: HH:MM."
                sleep 2
            fi
            ;;
        3)
            echo "Saliendo del programa."
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente de nuevo."
            sleep 2
            ;;
    esac
done

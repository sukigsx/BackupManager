#!/bin/bash

ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final
export version="1.0"
conexion="Sin comprobar"
software="Sin comprobar"
actualizado="No se ha podido comprobar la actualizacion del script"
archivo_local="BackupManager.sh" # Nombre del archivo local para comprobar la actualizacion
ruta_repositorio="https://github.com/sukigsx/BackupManager.git" #ruta del repositorio para actualizar y clonar con git clone
descripcion="Herramienta para copias de seguridad"

CONFIG_FILE="$ruta_ejecucion/backups.conf"
config_telegram="$ruta_ejecucion/telegram.conf"

#VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con el paquete que los contiene [comando a comprobar]="paquete a instalar"
    declare -A requeridos
    requeridos=(
        [git]="git"
        [nano]="nano"
        [curl]="curl"
        [diff]="diff"
        [ping]="ping"
        [find]="find"
        [rsync]="rsync"
        [ssh]="ssh"
    )

actualizar_script(){
#actualizar el script
#para que esta funcion funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: git diff xdotool


# Obtener la ruta del script
descarga=$(dirname "$(readlink -f "$0")")
git clone $ruta_repositorio /tmp/comprobar >/dev/null 2>&1

diff $descarga/$archivo_local /tmp/comprobar/$archivo_local >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    echo ""
    echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
    echo ""
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    actualizado="SI"
    sleep 2
else
    #hay que actualizar, comprueba y actualiza
    echo ""
    echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
    echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
    sleep 3
    cp -r /tmp/comprobar/* $descarga
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    echo ""
    echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
    echo ""
    sleep 2
    exit
fi
}

conexion(){
#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping
if ping -c1 google.com &>/dev/null
then
    conexion="SI"
    echo ""
    echo -e " Conexion a internet = ${verde}SI${borra_colores}"
else
    conexion="NO"
    echo ""
    echo -e " Conexion a internet = ${rojo}NO${borra_colores}"
fi
}

software_necesario(){
#funcion software necesario
#para que funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: which

echo ""
echo -e "${azul} Comprobando el software necesario.${borra_colores}"
echo ""
#which git diff ping figlet xdotool wmctrl nano fzf
#########software="which git diff ping figlet nano gdebi curl konsole" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for comando in "${!requeridos[@]}"; do
        which $comando &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                echo ""
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}sudo apt install ${requeridos[$comando]}${amarillo})${borra_colores}"
                echo -e ""
                echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
                echo ""; read p
                echo ""
                exit 1
            else
                echo " Instalando ${requeridos[$comando]}. Intento $contador/3."
                sudo apt install ${requeridos[$comando]} -y &>/dev/null
                let "contador=contador+1"
                which $comando &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando (${requeridos[$comando]})."
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    software="SI"
    sleep 2
}

#colores
#ejemplo: echo -e "${verde} La opcion (-e) es para que pille el color.${borra_colores}"
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

menu_info(){
clear
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script  =${borra_colores} $archivo_local"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion        =${borra_colores} $descripcion"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} (Correo scripts@mbbsistemas.com) (Web https://repositorio.mbbsistemas.es)${borra_colores}"
echo ""
}

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e " ${verde}- Gracias por utilizar mi script -${borra_colores}"
echo ""
exit
}

listar_tareas() {
    # comprobamos que el fichero de configuracion esta, sino se crea
    if [ -f "$CONFIG_FILE" ]; then
        echo ""
    else
        touch "$CONFIG_FILE"
        echo "NOMBRE|ORIGEN|DESTINO|CLAVE_ORIGEN|CLAVE_DESTINO" >> "$CONFIG_FILE"
        if [ -f "$CONFIG_FILE" ]; then
            echo ""
        else
            echo -e "${rojo} El fichero de configuracion no oesta o no se ha podido crear.${borra_colores}"
        fi
    fi

     if tail -n +2 "$CONFIG_FILE" | grep -q '\S'; then
        backups="si"
        echo -e "${azul} Listado de tus copias de seguridad${borra_colores}"
        echo ""
        column -t -s "|" $CONFIG_FILE | sed 's/^/ /'
    else
        backups="no"
        echo -e "${amarillo} No hay tareas de copias de seguridad configuradas.${borra_colores}"
    fi
}

agregar_tarea() {
    echo ""
    clear
    menu_info
    echo -e " ${azul}Añadir nueva tarea de copia de seguridad${borra_colores}"
    echo ""
    read -p " Nombre de la tarea: " nombre
    read -p " Ruta de origen (local o user@host:/ruta): " origen
    read -p " Ruta de destino (local o user@host:/ruta): " destino
    read -p " Clave SSH origen (o dejar vacío si no aplica): " clave_origen
    read -p " Clave SSH destino (o dejar vacío si no aplica): " clave_destino

    if [ -f "$CONFIG_FILE" ]; then
        echo "$nombre|$origen|$destino|$clave_origen|$clave_destino" >> "$CONFIG_FILE"
    else
        echo "NOMBRE|ORIGEN|DESTINO|CLAVE_ORIGEN|CLAVE_DESTINO" >> "$CONFIG_FILE"
        echo "$nombre|$origen|$destino|$clave_origen|$clave_destino" >> "$CONFIG_FILE"
    fi
    echo " Tarea añadida correctamente."
}

borrar_tarea() {
    clear
    echo ""
    menu_info
    echo -e "${azul} Borrado de copias de seguridad${borra_colores}"
    echo ""

    if tail -n +2 "$CONFIG_FILE" | grep -q '\S'; then
        column -t -s "|" $CONFIG_FILE | sed 's/^/ /'
    else
        echo -e "${amarillo} No hay tareas de copias de seguridad configuradas.${borra_colores}"
        sleep 3; return
    fi

    echo ""
    read -p " Ingrese el nombre de la tarea a borrar: " tarea

    # Verificamos si la tarea existe
    if ! grep -q "^$tarea|" "$CONFIG_FILE"; then
        echo ""
        echo -e "${rojo} No existe la tarea '${borra_colores}$tarea${rojo}' o te has confundido en el nombre.${borra_colores}"
        sleep 5; return
    fi

    # Eliminamos la tarea
    grep -v "^$tarea|" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo ""
    echo -e "${verde} Tarea '${borra_colores}$tarea${verde}' eliminada correctamente.${borra_colores}"; sleep 3
}

ejecutar_tarea() {
    tarea="$1"

    source $config_telegram
    clear
    echo ""
    menu_info
    echo -e "${azul} Ejecutar copia de seguridad${borra_colores}"
    echo ""
    if tail -n +2 "$CONFIG_FILE" | grep -q '\S'; then
        column -t -s "|" "$CONFIG_FILE" | sed 's/^/ /'
    else
        echo -e "${amarillo} No hay tareas de copias de seguridad configuradas.${borra_colores}"
        sleep 3; return
    fi

    if [[ -z "$tarea" ]]; then
        echo ""
        read -p "$(echo -e "${azul} Ingrese el nombre de la tarea a ejecutar: ${borra_colores}")" tarea
    fi

    linea=$(grep "^$tarea|" "$CONFIG_FILE" 2>/dev/null)
    if [[ -z "$linea" ]]; then
        echo -e "${amarillo} No existe la tarea '${borra_colores}$tarea${amarillo}'${borra_colores}"
        sleep 5; return
    fi

    origen=$(echo "$linea" | awk -F '|' '{print $2}')
    destino=$(echo "$linea" | awk -F '|' '{print $3}')
    clave_origen=$(echo "$linea"  | awk -F '|' '{print $4}')
    clave_destino=$(echo "$linea"  | awk -F '|' '{print $5}')

    echo ""
    echo -e "${azul} Ejecutando copia de seguridad:${borra_colores} $tarea"

    # --- Comprobar rsync local ---
    if ! command -v rsync >/dev/null 2>&1; then
        echo ""
        echo -e "${rojo} Error:${amarillo} rsync no está instalado en esta máquina.${borra_colores}"
        echo ""
        sleep 5
        return
    fi

    # Detección SSH (si contiene user@host:)
    case "$origen" in *"@"*":"* ) remoto_origen="si" ;; *) remoto_origen="no" ;; esac
    case "$destino" in *"@"*":"* ) remoto_destino="si" ;; *) remoto_destino="no" ;; esac

    resultado=1

    # --- CASO: remoto → remoto (dos pasos) ---
    if [[ "$remoto_origen" = "si" && "$remoto_destino" = "si" ]]; then
        echo -e "${amarillo} Realizando copia remoto → remoto en dos pasos...${borra_colores}"
        tmp="/tmp/rsync_tmp_$$"
        mkdir -p "$tmp"

        # Paso 1: origen remoto -> tmp local
        if [[ -n "$clave_origen" ]]; then
            rsync -avzh --delete -e "ssh -i $clave_origen" --rsync-path="sudo rsync" "$origen" "$tmp"
        else
            rsync -avzh --delete -e "ssh" --rsync-path="sudo rsync" "$origen" "$tmp"
        fi
        if [[ $? -ne 0 ]]; then
            echo -e "${rojo} Error copiando desde el origen remoto.${borra_colores}"
            rm -rf "$tmp"; sleep 3; return
        fi

        # Paso 2: tmp local -> destino remoto
        if [[ -n "$clave_destino" ]]; then
            rsync -avzh --delete -e "ssh -i $clave_destino" "$tmp/" "$destino"
        else
            rsync -avzh --delete -e "ssh" "$tmp/" "$destino"
        fi
        resultado=$?
        rm -rf "$tmp"
    fi

    # --- CASO: remoto -> local ---
    if [[ "$remoto_origen" = "si" && "$remoto_destino" = "no" ]]; then
        if [[ -n "$clave_origen" ]]; then
            rsync -avzh --delete -e "ssh -i $clave_origen" --rsync-path="sudo rsync" "$origen" "$destino"
        else
            rsync -avzh --delete -e "ssh" --rsync-path="sudo rsync" "$origen" "$destino"
        fi
        resultado=$?
    fi

    # --- CASO: local -> remoto ---
    if [[ "$remoto_origen" = "no" && "$remoto_destino" = "si" ]]; then
        if [[ -n "$clave_destino" ]]; then
            rsync -avzh --delete -e "ssh -i $clave_destino" "$origen" "$destino"
        else
            rsync -avzh --delete -e "ssh" "$origen" "$destino"
        fi
        resultado=$?
    fi

    # --- CASO: local -> local ---
    if [[ "$remoto_origen" = "no" && "$remoto_destino" = "no" ]]; then
        rsync -avzh --delete "$origen" "$destino"
        resultado=$?
    fi

    if [[ $resultado -eq 0 ]]; then
        echo ""
        echo -e "${verde} Copia completada de ${borra_colores}$tarea ${verde}correctamente.${borra_colores}"
        #envia telegram si esta configurado
        if [ "$envio_telegram" = "si" ]; then
            wget -O - "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=Backup de $tarea ( CORRECTO )" > /dev/null 2>&1
        fi
        sleep 5
    else
        echo ""
        echo -e "${rojo} Error en la copia ${borra_colores}$tarea"
        #envia telegram si esta configurado
        if [ "$envio_telegram" = "si" ]; then
            wget -O - "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=Backup de $tarea ( FALLO )" > /dev/null 2>&1
        fi
        sleep 5
    fi
}


editar_fichero_configuracion_backups() {
    if [ -f $CONFIG_FILE ];then
        nano $CONFIG_FILE
    else
        echo ""
        echo -e "${amarillo} No existe el fichero de configuracion de backups"
        sleep 3
    fi
}

editar_fichero_configuracion_telegram() {
    if [ -f $config_telegram ];then
        nano $config_telegram
    else
        echo ""
        echo -e "${amarillo} No existe el fichero de configuracion de telegram${borra_colores}"
        sleep 3
    fi
}

configurar_telegram() {
clear
    echo ""
    menu_info
    echo -e "${azul} Configuracion de envio a telegram${borra_colores}"
    echo ""
    if [ -f $config_telegram ]; then
        rm $config_telegram
    fi
    read -p " Introduce el Bot_Token: " BOT_TOKEN
    read -p " Introduce el Chat_Id: " CHAT_ID
    echo ""
    echo "BOT_TOKEN=$BOT_TOKEN" >> $config_telegram
    echo "CHAT_ID=$CHAT_ID" >> $config_telegram
    echo 'configurado_telegram="si"' >> $config_telegram
    echo 'envio_telegram="si"' >> $config_telegram
    echo ""
    echo -e "${verde} Configuracion correcta${borra_colores}"; sleep 2
}

comprobar_envio_telegram() {
    if [ -f $config_telegram ]; then
        source $config_telegram
        wget -O - "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=Comprobacion de envio de $0 Diseñado por Sukigsx" > /dev/null 2>&1
        echo ""
        echo -e "${verde} Comando enviado${borra_colores}"; sleep 2
    else
        echo ""
        echo -e "${amarillo} No tienes configurado el envio a telegram${borra_colores}"; sleep 2
    fi
}

envio_a_telegram() {
    if [ -f $config_telegram ]; then
        source $config_telegram
        if [ "$envio_telegram" = "si" ]; then
            sed -i 's/^envio_telegram="si"/envio_telegram="no"/' $config_telegram
        else
            sed -i 's/^envio_telegram="no"/envio_telegram="si"/' $config_telegram
        fi
    else
        echo "no esta configurado el telegram"; sleep 5
    fi
}

menu() {
    while true; do
        if [ -f $config_telegram ]; then
            source $config_telegram
        else
            configurado_telegram="no"
            envio_telegram="no"
        fi
        clear
        menu_info
        echo -e "${azul} Menu de opciones de ${borra_colores}$archivo_local"; echo ""
        echo -e "${azul}  1)${borra_colores} Añadir nueva tarea"
        echo -e "${azul}  2)${borra_colores} Ejecutar una tarea"
        echo -e "${azul}  3)${borra_colores} Borrar tarea"
        echo -e "${azul}  4)${borra_colores} Editar fichero configuracion backups"
        echo -e ""
        echo -e "${azul}  5)${borra_colores} Configurar envio a telegram"
        echo -e "${azul}  6)${borra_colores} Editar fichero configuracion telegram"
        echo -e "${azul}  7)${borra_colores} Envio de prueba a telegram"
        echo -e "${azul}  8)${borra_colores} Activar/Desactivar envio a telegram"
        echo ""
        echo -e "${azul} 99)${borra_colores} Salir"
        echo ""; echo -e "${azul} (Telegram configurado =${borra_colores} $configurado_telegram${azul}) (Envio notificaciones =${borra_colores} $envio_telegram${azul})${borra_colores}"
        listar_tareas
        echo ""
        #read -p " Seleccione una opción: " opcion
        read -p "$(echo -e "${azul} Seleccione una opción: ${borra_colores}")" opcion

        case $opcion in
            1) agregar_tarea ;;
            2) ejecutar_tarea ;;
            3) borrar_tarea ;;
            4) editar_fichero_configuracion_backups ;;
            5) configurar_telegram ;;
            6) editar_fichero_configuracion_telegram ;;
            7) comprobar_envio_telegram ;;
            8) envio_a_telegram ;;
            99) ctrl_c ;;
            *) echo -e "\033[1A\033[2K${amarillo} Opción no válida${borra_colores}"; sleep 2 ;;
        esac
    done
}

#EMPIEZA LO GORDO
menu_info
conexion
if [ "$conexion" = "SI" ]; then
    actualizar_script
    if [ "$actualizado" = "SI" ]; then
        software_necesario
        if [ "$software" = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
        else
            echo ""
        fi
    else
        software_necesario
        if [ "$software" = "SI" ]; then
            export software="SI"
            export conexion="NO"
            export actualizado="No se ha podido comprobar la actualizacion del script"
        else
            echo ""
        fi
    fi
else
    software_necesario
    if [ "$software" = "SI" ]; then
        export software="SI"
        export conexion="NO"
        export actualizado="No se ha podido comprobar la actualizacion del script"
    else
        echo ""
    fi
fi

# --- MODO ARGUMENTOS ---
if [ $# -gt 0 ]; then
    case "$1" in
        listar) listar_tareas ;;
        agregar) agregar_tarea ;;
        ejecutar_tarea) ejecutar_tarea "$2" ;;
        ejecutar_todas) ejecutar_todas ;;
        *)
            echo "Uso:"
            echo "  $0 listar"
            echo "  $0 agregar"
            echo "  $0 ejecutar_tarea nombre"
            echo "  $0 ejecutar_todas"
            ;;
    esac
    exit
fi
menu

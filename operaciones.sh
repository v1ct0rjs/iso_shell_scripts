#!/bin/bash


# Funcion para crear un usuario
function crear_usuario() {
    clear
    echo "Introduzca el nombre del usuario a crear: "                       # Pedimos el nombre del usuario
    read nombre_usuario                                                     # Guardamos el nombre del usuario en la variable nombre_usuario
    sudo useradd $nombre_usuario                                            # Creamos el usuario con el nombre introducido
    echo "Se ha creado el usuario "$nombre_usuario" correctamente."         # Mostramos un mensaje de confirmación
    echo "Introduzca la contraseña para el usuario: "                       # Pedimos la contraseña del usuario
    read -s password                                                        # Guardamos la contraseña del usuario en la variable password
    echo $password | sudo passwd --stdin $nombre_usuario                    # Asignamos la contraseña al usuario passwd --stdin entrada estanda lee la clave desde la variable
    echo "Se ha asignado la contraseña al usuario "$nombre_usuario" correctamente." # Mostramos un mensaje de confirmación
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}

# Funcion para crear un grupo
function crear_grupo() {
    clear
    echo "Introduzca el nombre del grupo a crear: "                          # Pedimos el nombre del grupo
    read nombre_grupo                                                        # leemos el nombre del grupo
    sudo groupadd $nombre_grupo                                              # Creamos el grupo con el nombre introducido
    echo "Grupo "$nombre_grupo" creado correctamente."                       # Mostramos un mensaje de confirmación
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}

# Funcion para agregar un usuario a un grupo existente
function agregar_usuario_grupo() {
    clear
    while true; do                                                            # Bucle para comprobar que el usuario existe
        echo "Introduzca el nombre del usuario: "                             # Pedimos el nombre del usuario
        read nombre_usuario                                                   # Guardamos el nombre del usuario en la variable nombre_usuario
        if [ $(cat /etc/passwd | grep $nombre_usuario | wc -l) -eq 0 ]; then  # Comprobamos si el usuario existe
            echo "El usuario no existe."                                      # Si no existe, mostramos un mensaje de error
            echo
            echo "Pulse una tecla para continuar..."                          # Pedimos que pulse una tecla para continuar
            read -n 1
            continue                                                          # Si no existe, continuamos con el bucle
        fi
        break                                                                 # Si el usuario existe, salimos del bucle
    done

    while true; do                                                            # Bucle para comprobar que el grupo existe
        echo "Introduzca el nombre del grupo: "                               # Pedimos el nombre del grupo
        read nombre_grupo
        if [ $(cat /etc/group | grep $nombre_grupo | wc -l) -eq 0 ]; then     # Comprobamos si el grupo existe
            echo "El grupo no existe."
            echo
            echo "Pulse una tecla para continuar..."
            read -n 1
            continue                                                          # Si no existe, continuamos con el bucle
        fi
        break
    done

    sudo usermod -a -G $nombre_grupo $nombre_usuario                          # Añadimos el usuario al grupo
    echo "Usuario agregado al grupo correctamente."
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}
# Funcion para agregar un usuario a un grupo no existente
function agregar_usuario_grupo_no_existente() {
    clear
    while true; do                                                            # Bucle para comprobar que el usuario existe
        echo "Introduzca el nombre del usuario: "                             # Pedimos el nombre del usuario
        read nombre_usuario                                                   # Guardamos el nombre del usuario en la variable nombre_usuario
        if [ $(cat /etc/passwd | grep $nombre_usuario | wc -l) -eq 0 ]; then  # Comprobamos si el usuario existe
            echo "El usuario no existe."                                      # Si no existe, mostramos un mensaje de error
            echo
            echo "Pulse una tecla para continuar..."
            read -n 1
            continue                                                          # Si no existe, continuamos con el bucle
        fi
        break                                                                 # Si el usuario existe, salimos del bucle
    done

    echo "Introduzca el nombre del grupo para crear: "                        # Pedimos el nombre del grupo
    read nombre_grupo
    sudo groupadd $nombre_grupo                                               # Creamos el grupo con el nombre introducido
    sudo usermod -a -G $nombre_grupo $nombre_usuario                          # Añadimos el usuario al grupo
    echo "Usuario agregado al nuevo grupo correctamente."
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}

# Funcion para eliminar un usuario de un grupo
function borra_usuario_grupo() {
    clear
    while true; do                                                            # Bucle para comprobar que el usuario existe
        echo "Introduzca el nombre del usuario: "                             # Pedimos el nombre del usuario
        read nombre_usuario                                                   # Guardamos el nombre del usuario en la variable nombre_usuario
        if [ $(cat /etc/passwd | grep $nombre_usuario | wc -l) -eq 0 ]; then  # Comprobamos si el usuario existe
            echo "El usuario no existe."                                      # Si no existe, mostramos un mensaje de error
            echo
            echo "Pulse una tecla para continuar..."
            read -n 1
            continue                                                          # Si no existe, continuamos con el bucle
        fi
        break                                                                 # Si el usuario existe, salimos del bucle
    done

    while true; do                                                            # Bucle para comprobar que el grupo existe
        echo "Introduzca el nombre del grupo: "                               # Pedimos el nombre del grupo
        read nombre_grupo                                                     # Guardamos el nombre del grupo en la variable nombre_grupo
        if [ $(cat /etc/group | grep $nombre_grupo | wc -l) -eq 0 ]; then     # Comprobamos si el grupo existe
            echo "El grupo no existe."                                        # Si no existe, mostramos un mensaje de error
            echo
            echo "Pulse una tecla para continuar..."                          # Pedimos que pulse una tecla para continuar
            read -n 1
            continue                                                          # Si no existe, continuamos con el bucleº
        fi
        break                                                                 # Si el grupo existe, salimos del bucle
    done

    sudo deluser $nombre_usuario $nombre_grupo                                # Eliminamos el usuario del grupo
    echo "Usuario eliminado del grupo correctamente."                         # Mostramos un mensaje de confirmación
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}

# Funcion para mostrar el listado de usuarios de un grupo específico
function lista_usuarios_grupo() {
    clear
    while true; do                                                              # Bucle para comprobar que el grupo existe
        echo "Introduzca el nombre del grupo: "                                 # Pedimos el nombre del grupo
        read nombre_grupo
        if [ $(cat /etc/group | grep $nombre_grupo | wc -l) -eq 0 ]; then       # Comprobamos si el grupo existe
            echo "El grupo no existe."
            echo
            echo "Pulse una tecla para continuar..."
            read -n 1
            continue                                                            # Si no existe, continuamos con el bucle
        fi
        break                                                                   # Si el grupo existe, salimos del bucle
    done
    grep $nombre_grupo /etc/group | cut -d: -f4                                 # Mostramos los usuarios del grupo
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1

}
# Funcion para mostrar todos los grupos existentes en el sistema
function lista_grupos() {
    clear
    cat /etc/group | cut -d: -f1                                                 # Mostramos los grupos del sistema
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
}

# Funcion para eliminar un usuario Modificación práctica
function eliminar_usuario() {
    clear
    while true; do
        echo "Introduzca el nombre del usuario a eliminar: "                        # Pedimo el usuario a borrar y lo almacenamos en una variable
        read nombre_usuario
        if [ $(cat /etc/passwd | grep $nombre_usuario | wc -l) -eq 0 ]; then        # Comprobamos si el usuario existe
            echo "El usuario no existe."
            echo
            echo "Pulse una tecla para continuar..."
            read -n 1
            continue                                                                # Si no existe, continuamos con el bucle
        fi
        break                                                                       # Si el usuario existe, salimos del bucle
    done
    echo "Información de " $nombre_usuario "en /etc/password"                       # Mostramos la información del usuario
    grep "^$nombre_usuario:" /etc/passwd | cut -d: -f1-5                            # usamos grep para buscar el usuario y cut para mostrar los campos
    echo
    echo "Pulse una tecla para continuar..."
    read -n 1
    echo "¿Está seguro de que desea eliminar el usuario $nombre_usuario? (s/n)"     # Preguntamos si está seguro de eliminar el usuario
    read respuesta
    if [ $respuesta = "s" ]; then                                                   # Si la respuesta es afirmativa, eliminamos el usuario
        sudo userdel -r $nombre_usuario                                             # Eliminamos el usuario
        echo "Usuario eliminado correctamente."
    else
        echo "Operación cancelada."                                                 # Si la respuesta es negativa, mostramos un mensaje de cancelación
    fi
    echo
    echo "Pulse una tecla para continuar..."                                        # Pedimos que pulse una tecla para continuar
    read -n 1                                                                       # Leemos la tecla pulsada
}
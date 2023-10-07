#!/bin/bash

registrarSocio(){
    echo "Registrar Socio"
    read -p "Ingrese nombre: " nombre
    read -p "Ingrese cedula: " cedula;
    while true;
    do
        if validar_cedula $cedula; then 
            break;
        fi 
        read -p "Cedula incorrecta ingrese con el formato correcto: " cedula;
    done
    read -p "Ingrese nombre de mascota: " nombreM;
    read -p "Ingrese edad mascota: " edadM
    read -p "Ingrese email de contacto: " email;
    read -p "Ingrese telefono de contacto: " tel;
    echo "$nombre,$cedula,$nombreM,$edadM,$email,$tel" >> socios.txt 
    echo "Socio registrado con exito"
    echo " "
}

validar_cedula() {
    [[ $1 =~ ^[0-9]{8}$ ]] # && [[ ${#1} -eq 8 ]]
}

validar_cedulaExiste(){
    [[ $1 =~ ^[0-9]{8}$ ]] && grep -q $1 "socios.txt"
}

validar_fecha() {
    [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d $1 &>/dev/null
}

validar_fecha2(){
    fecha_ingresada=$(date -d $1 +%s)
    fecha_actual=$(date +%s)
    if (( fecha_ingresada >= fecha_actual )); then
        return 0
    else
        echo "La fecha no puede estar en el pasado."
        return 1
    fi
}

validarMascotaDueno(){
    grep -q $1 "socios.txt" 
}

valida_hora(){
    [[ $1 =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]
}

agendarCita(){
    echo " "
    echo "1. Agendar nueva cita"
    echo "2. Consultar citas pendientes"
    echo "3. Eliminar cita programada"
    read -p "Seleccione una opción: " opcion
    case $opcion in
        1)
            read -p "Ingrese la cédula del dueño: " cedula
            while true;
            do
                if validar_cedulaExiste $cedula; then 
                    break;
                fi 
                read -p "Cedula incorrecta ingrese con el formato correcto y que ya este registrado: " cedula;
            done
            read -p "Ingrese el nombre de la mascota: " mascota
            while true;
            do
                a="$mascota $cedula"
                if validarMascotaDueno $a; then
                    break;
                fi
                read -p "La mascota debe pertenecer al dueño: " mascota
            done
            read -p "Ingrese el motivo de la cita: " motivo
            read -p "Ingrese el costo de la cita: " costo
            read -p "Ingrese la fecha de la cita ( ej. aaaa-mm-dd): " fecha
            while true;
            do
                if validar_fecha $fecha && validar_fecha2 $fecha; then
                    break;
                fi
                read -p "Fecha inválida. Debe seguir el formato ISO 8601 (ej. aaaa-mm-dd): " fecha
            done
            read -p "Ingrese hora (ej hh:mm): " hora
            while true;
            do
                if valida_hora $hora; then
                    break;
                fi
                read -p "Hora incorrecta, escriba en el formato indicado: " hora 
            done
            echo "$cedula,$mascota,$motivo,$costo,$fecha" >> citas.txt
            echo "Cita agendada."
            echo " "
            ;;
        2)
            cat "citas.txt"
            ;;
        3)
            read -p "Ingrese la cédula del dueño para eliminar la cita: " cedula
            while true;
            do
                if validar_cedula $cedula; then 
                    break;
                fi 
                read -p "Cedula incorrecta ingrese con el formato correcto: " cedula;
            done
            sed -i "/$cedula/d" "citas.txt"
            echo "Cita eliminada."
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
}

actualizar_stock() {
    echo "Categorías: medicamentos, suplementos, accesorios"
    read -p "Ingrese la categoría del artículo: " categoria
    if ! validar_categoria $categoria; then
        echo "Categoría inválida."
        return
    fi
    read -p "Ingrese el código del artículo: " codigo
    if grep -q "$codigo" "articulos.txt"; then
        read -p "Ingrese la cantidad a agregar: " cantidad
        sed -i "/$codigo/s/(.),([0-9])/\1,$((\2 + cantidad))/" "articulos.txt"
        echo "Stock actualizado exitozamente."
    else
        read -p "Ingrese el nombre del artículo: " nombre
        read -p "Ingrese el precio del artículo: " precio
        read -p "Ingrese la cantidad inicial del artículo: " cantidad
        echo "$categoria,$codigo,$nombre,$precio,$cantidad" >> "articulos.txt"
        echo "Artículo agregado."
    fi
}

consultarCita(){
    echo "a"
}

eliminarCita(){
    echo "7"
}

agregarArticulo(){
    echo "7"
}

ventaArticulo(){
    echo "7"
}

informeMensual(){
    echo "bocaaaa"
}

menu(){
menu=0;

while [ $menu -eq 0 ];
do
    echo "-----------------------------------"
    echo "Veterinaria, ingrese su operacion";
    echo "1) Registrar socio"   
    echo "2) Agendar cita"
    echo "3) Consultar cita"
    echo "4) Eliminar cita"
    echo "5) Agregar articulo"
    echo "6) Venta articulo"
    echo "7) Informe mensual"
    echo "Cualquier otra tecla para salir"
    echo "-----------------------------------"
    echo " "
    read entrada;
    case "${entrada}"
    in
        1) registrarSocio;;
        2) agendarCita;;
        3) consultarCita;;
        4) eliminarCita;;
        5) agregarArticulo;;
        6) ventaArticulo;;
        7) informeMensual;;
        *) menu=1;;
    esac    
done
}

menu
#!/bin/bash

# Archivo de origen
input="data2.txt"

# Comprobamos que el archivo exista
if [ ! -f "$input" ]; then
  echo "El archivo $input no existe."
  exit 1
fi

# Cambiamos los separadores de coma a barra vertical y guardamos en un temporal
awk '{gsub(/,/, "|"); print}' "$input" > tmp_data.txt

# Obtenemos la lista de géneros únicos (ignorando la cabecera)
awk -F"|" 'NR>1 {print $3}' tmp_data.txt | sort | uniq > generos.txt

# Creamos un fichero para cada género
while read genero; do
  # Reemplazamos espacios por guiones bajos para el nombre del fichero
  nombre_fichero=$(echo "$genero" | tr ' ' '_' | tr '/' '_')
  # Filtramos las líneas que pertenecen a ese género
  awk -F"|" -v gen="$genero" '$3 == gen' tmp_data.txt > "${nombre_fichero}.txt"
  echo "Archivo creado: ${nombre_fichero}.txt"
done < generos.txt

# Limpiamos archivos temporales
rm tmp_data.txt generos.txt


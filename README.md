| :warning: Alerta: Este proyecto está en desarrollo          |
|:---------------------------|
| Ten en cuenta que este proyecto aún no está completo y se encuentra en desarrollo. Si tienes alguna sugerencia o encuentras algún problema, por favor, no dudes en informarlo. Tu feedback es muy importante para mejorar este pequeño proyecto. ¡Gracias por tu interés!

# Proyecto: Hardware Detection

Este proyecto tiene como objetivo detectar los componentes de hardware de tu equipo, tales como disco duro, memoria RAM, procesador, placa de video y adaptador Wi-Fi, para luego convertirlos en un archivo JSON.

## Requerimientos

El script ha sido probado en Windows 10. Para ejecutar el script, es necesario tener permisos de administrador.

## Instrucciones de uso

1. Clona o descarga este repositorio en tu equipo.
2. Abre una ventana de línea de comandos con permisos de administrador.
3. Navega hasta el directorio donde se encuentra el código fuente del proyecto.
4. Ejecuta el archivo `hardware.bat`.
5. Una vez que el proceso haya finalizado, encontrarás el archivo JSON generado en el directorio raíz del proyecto.

## Información del archivo JSON generado

El archivo JSON generado incluirá la siguiente información:

- Información de la memoria RAM:
  - Capacidad
  - Factor de forma
  - Tipo de memoria
  - Velocidad

- Información del procesador:
  - Fabricante
  - Modelo
  - Número de núcleos
  - Velocidad

- Información del disco:
  - Marca
  - Tamaño

- Información de la placa de video:
  - Nombre
  - Memoria de video
  - Procesador de video

- Información del adaptador Wi-Fi:
  - Nombre de la placa Wi-Fi
  - Fabricante de la placa Wi-Fi

## Licencia

Este proyecto se encuentra bajo la Licencia MIT. Para más detalles, consulta el archivo LICENSE.md.

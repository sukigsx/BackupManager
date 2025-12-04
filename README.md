✅ ¿Para qué sirve este script?

Este script es una herramienta interactiva para gestionar copias de seguridad (backups) usando rsync, tanto locales como remotas, y con soporte opcional de notificaciones por Telegram.

En resumen, sirve para:

🔧 1. Crear, listar, ejecutar y borrar tareas de backup

El script mantiene un archivo de configuración donde guarda:

Nombre de la tarea

Carpeta de origen

Carpeta de destino

Claves SSH para origen/destino (si hacen falta)

Con esto puedes:

✔ Añadir nuevas tareas de copia de seguridad

(local → local, local → remoto, remoto → local o remoto → remoto)

✔ Ver un listado ordenado de tus tareas
✔ Borrar tareas que ya no usas
✔ Ejecutar una tarea manualmente desde el menú
✔ Ejecutar tareas desde la terminal por argumentos

Ej.: ./BackupManager.sh ejecutar_tarea nombre_de_la_tarea

🔄 2. Realizar las copias con rsync (automáticas según el tipo)

El script detecta:

si el origen es local o remoto

si el destino es local o remoto

si necesita clave SSH

si rsync está instalado

Y ejecuta la copia de forma correcta en estos escenarios:

local → local

local → remoto

remoto → local

remoto → remoto (hace copia en dos pasos usando /tmp)

📲 3. Enviar notificaciones por Telegram (opcional)

Puedes configurarlo para que:

Al completar un backup envíe un mensaje indicando si salió OK o FALLO.

Enviar un mensaje de prueba.

Activar o desactivar las notificaciones.

🛠 4. Editar fácilmente los archivos de configuración

Incluye opciones para abrir con nano:

el fichero de tareas de backup

la configuración de Telegram

🖥 5. Menú interactivo en pantalla con colores

Cada función se muestra con un menú limpio y coloreado.
Presionando Ctrl + C el script muestra un mensaje de salida elegante.

📌 En pocas palabras

Es un gestor completo de tareas de copia de seguridad, con rsync, soporte para entornos remotos y notificaciones por Telegram.

## Instalacion  
Clonar el repositorio y ejecutar BackupManager.sh

```  
git clone https://github.com/sukigsx/BackupManager.git
```

Tambien puedes utilizar mi script (ejecutar_scripts).

```  
git clone https://github.com/sukigsx/ejecutar_scripts.git  
```

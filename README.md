🗂️ Gestor de Copias de Seguridad con rsync — Descripción General

Este script es una herramienta interactiva diseñada para gestionar copias de seguridad (backups) utilizando rsync, con soporte para entornos locales, remotos y notificaciones por Telegram.

✅ ¿Para qué sirve este script?

Este script permite administrar tareas de copia de seguridad de manera sencilla y automatizada. Sus funciones principales son:

🔧 1. Gestión completa de tareas de backup

El script permite:

Crear nuevas tareas de backup

Listar las tareas existentes

Ejecutar una tarea individual

Borrar tareas

Modificar los archivos de configuración

Cada tarea incluye:

Nombre de la copia

Ruta de origen

Ruta de destino

Clave SSH para origen (opcional)

Clave SSH para destino (opcional)

Todo se guarda en un fichero de configuración editable.

🔄 2. Realización automática de copias con rsync

El script usa rsync y detecta automáticamente el tipo de copia según el origen y destino:

Local → Local

Local → Remoto

Remoto → Local

Remoto → Remoto
(Hace la copia en dos pasos usando un directorio temporal.)

También verifica si rsync está instalado y muestra errores claros si falta.

📲 3. Notificaciones por Telegram (opcional)

Permite configurar un bot de Telegram para recibir mensajes:

Cuando un backup se completa correctamente

Cuando ocurre un fallo

Para enviar un mensaje de prueba

Para activar o desactivar el envío de notificaciones

🛠 4. Edición sencilla de configuraciones

Desde el menú puedes abrir con nano:

El fichero de tareas de backup

El fichero de configuración de Telegram

🖥 5. Menú interactivo con colores

El script muestra:

Un menú principal fácil de navegar

Información del script

Listado de tareas formateado

Mensajes coloreados para mayor claridad

Incluye además un manejador para Ctrl + C que limpia la pantalla y muestra un mensaje elegante de salida.

📌 Resumen breve

Es un gestor completo de tareas de copia de seguridad con rsync, compatible con rutas locales y remotas, y con sistema opcional de notificaciones por Telegram.

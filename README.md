# BackupManager
Es un gestor de copias de seguridad (backups) hecho en Bash.

Permite:

✅ Crear tareas de copia

▶️ Ejecutarlas

❌ Borrarlas

📤 Exportar la configuración

📩 Enviar avisos por Telegram

🖥️ Usarlo con menú interactivo o por comandos

# ¿Qué hace cada parte?
## 1 listar_tareas()

Comprueba si existe el fichero de configuración.

Si no existe, lo crea con una cabecera.

Muestra todas las tareas guardadas en formato tabla.

Si no hay tareas, lo indica.

👉 Básicamente: muestra tus backups configurados.

## 2 agregar_tarea()

Permite crear una nueva copia de seguridad:

Pide un nombre.

Comprueba que no exista ya.

Pide ruta de origen.

Pide ruta de destino (debe estar en tu HOME).

Si la carpeta destino no existe, pregunta si quiere crearla.

Guarda todo en el fichero de configuración.

👉 Es el asistente para crear nuevos backups.

## 3 borrar_tarea()

Muestra las tareas.

Pide el nombre de la que quieres borrar.

Si existe, la elimina del fichero.

👉 Borra una tarea configurada.

## 4 ejecutar_tarea()

Es la parte más importante 🔥

Hace realmente la copia usando rsync.

Detecta automáticamente si:

Es local → local

Es local → remoto

Es remoto → local

Es remoto → remoto (lo hace en 2 pasos)

Si hay error, lo muestra.
Si está configurado Telegram, manda notificación.

👉 Es el motor que hace el backup real.

## 5 Telegram

Permite:

Configurar Bot Token y Chat ID

Activar/desactivar notificaciones

Enviar mensaje de prueba

Cuando un backup termina:

✔️ Envía "CORRECTO"

❌ Envía "FALLO"

## 6 Exportar configuraciones

Permite copiar:

backups.conf

telegram.conf

Al HOME del usuario.

## 7 Parte final del script

Antes de mostrar el menú:

Comprueba conexión a internet

Comprueba si hay actualizaciones

Comprueba si el software necesario está instalado

Luego arranca el menú

## 8 También funciona por comandos

Puedes ejecutarlo así:

./BackupManager.sh listar
./BackupManager.sh agregar
./BackupManager.sh ejecutar_tarea nombre

Sin entrar al menú.

## Instalacion
Clonar el repositorio
```
git clone https://github.com/sukigsx/BackupManager.git
```

Descargar script con WGET
```
wget -O BackupManager.sh https://raw.githubusercontent.com/sukigsx/BackupManager/refs/heads/main/BackupManager.sh && chmod +x BackupManager.sh
```

Tambien puedes ejecutar mi script de instalaciones
```
git clone https://github.com/sukigsx/ejecutar_scripts.git
```

```
cd Ejecutar_scripts.sh
```

```
bash Ejecutar_scripts.sh
```

# documentation

Para la instalación y despliegue de los microservicios de SAP, se deben seguir los siguientes pasos:

## Requerimientos previos:
1. Instalar Nodejs 14
2. Instalar Git
3. Instalar MongoDB 4.0.2
si surge el problema de iniciar el servicio de mongodb seguir instalar el siguiente programa:
```
https://www.itechtics.com/microsoft-visual-c-redistributable-versions-direct-download-links/
```
4. Instalar las utilidades o herramientas de mongodb para poder exportar/importar base de datos. esto es solo para windows

Desps de instalar mongo, en el shell del mismo crear la bd:
```
use surCompany
```
Crear usuario:
```
db.createUser({user:'SUR',pwd:'SUR123',roles:[{role:'readWrite',db:'surCompany'}]})
```

## Backups
Para crear un backup (copia de la base de datos) de la base de datos se ejecuta el siguiente comando:
```
mongodump -u SUR -p SUR123 --authenticationDatabase=surCompany -o dump/SUR
```
donde **-o** es el parametro para indicar donde se va a guardar la copia de la base de datos.

Para restaurar (importar) una copia de la base de datos se ejecuta el siguiente comando:
```
mongorestore ./ -u SUR -p SUR123 --authenticationDatabase surCompany -d surCompany
```

## Instalación de los MS y Despliegue

### Instalación local
1) Ejecutar el script número 0:
``
./0_download_repos.bash
``

2) Ejecutar el script número 6:
``
./6_npm_install.bash
``

- Se debe colocar en el archivo .env del MS sap_api la ip de conección a sap bussines en el servidor de surCompany la cual es: _192.168.160.12_ y el puerto _50000_.

- En el MS de hook se debe colocar el dominio respectivo para la comunicación de vtex con el mismo.

3) Ejecutar el script número 3:
``
1_deploy_localhost.bash
``

### Instalación con docker
1) Ejecutar el script número 0:
``
./0_download_repos.bash
``

2) Ejecutar el script número 7:
``
./7_export_env_file.bash
``

3) Ejecutar el script número 3:
``
3_deploy_docker.bash sur .env
``

### Instalar los MS como servicios en windows

1) Ejecutar el script número 9:
``
9_deploy_how_service.bash start
``
 Para el caso de reiniciar, se deben detener, eliminar e iniciar de nuevo.
 - Nota: La función eliminar los detiene primero.
 ``
9_deploy_how_service.bash stop
``
``
9_deploy_how_service.bash delete
``
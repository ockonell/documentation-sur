# documentation

Para la instalación y despliegue de los microservicios de SAP, se deben seguir los siguientes pasos:

## Requerimientos previos:
1. Instalar Nodejs 14
2. Instalar Git
3. Instalar las llaves ssh para comunicación directa con Git sin acceso de credenciales, estas se encuentran
en el archivo _llaves.md_. para esto se debe utilizar el bash de git y crear la carpeta .ssh en la dirección ~/
con el siguiente comando:
```
mkdir ~/.ssh
```
y dentro de la carpeta (cd .ssh/) crear los archivos y agregar las llaves respectivas a cada uno de ellos de la siguiente manera:
```
cd ~/.ssh
vi id_rsa
```
**Nota**: para guardar con vi se presiona la tecla escape (esc) y se escribe las letras q (para salir) o wq (para guardar y salir).

presionar la tecla _i_ y agregar la llave correspondiente como dice el archivo _llaves.md_, y se hace lo mismo para el siguiente archivo
```
vi id_rsa.pub
```

5. Instalar MongoDB 4.0.2
si surge el problema de iniciar el servicio de mongodb seguir instalar el siguiente programa:
```
https://www.itechtics.com/microsoft-visual-c-redistributable-versions-direct-download-links/
```

Desps de instalar mongo, en el shell del mismo crear la bd:
```
use surCompany
```
Crear usuario:
```
db.createUser({user:'SUR',pwd:'SUR123',roles:[{role:'readWrite',db:'surCompany'}]})
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

- Se debe colocar en los archivos .env de los MS core, product y order la ip de conección a sap bussines,
en el servidor de surCompany es: _192.168.160.12_ y el puerto _50000_.

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
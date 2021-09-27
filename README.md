# documentation

Para la instalación y despliegue de los microservicios de SAP, se deben seguir los siguientes pasos:

## Requerimientos previos:
1. Instalar Docker
2. Instalar MongoDB
3. Instalar Git
4. Instalar las llaves ssh para comunicación directa con Git sin acceso de credenciales

## Instalación de los MS y Despliegue
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

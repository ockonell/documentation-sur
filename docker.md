Este manual está basado en la documentación oficial: [Docker](https://docs.docker.com/engine/install/centos/)

***
### Prerequisitos:
  - Conocimientos básicos sobre Linux
  - Usuario Administrador del sistema
  - Conectividad a Internet
  - Acceso por consola a una instalación de CentOS 8




***
## 1. Instalar Docker

### Preinstalación

Se debe realizar la instalación de container.io para corregir el error del despliegue de docker_compose.yml

El comando es el siguiente:

```sh
yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
```

### Instalar usando el repositorio.

Antes de instalar Docker Engine por primera vez en una nueva máquina host, debe configurar el repositorio de Docker. Luego, puede instalar y actualizar Docker desde el repositorio.

### CONFIGURAR EL REPOSITORIO

Instale el yum-utilspaquete (que proporciona la yum-config-manager utilidad) y configure el repositorio estable .

```sh
sudo yum install -y yum-utils
```

```sh
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
### INSTALAR DOCKER ENGINE

Instale la última versión de Docker Engine y containerd, o vaya al siguiente paso para instalar una versión específica:

```sh
sudo yum install docker-ce docker-ce-cli containerd.io
```
Si se le solicita que acepte la clave GPG, verifique que la huella digital coincida 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35 y, de ser así, acéptela.

## Inicia Docker.
```sh
sudo systemctl start docker
```
 Verifique que Docker Engine esté instalado correctamente ejecutando la hello-world imagen:
 
 ```sh
sudo docker run hello-world
```
 ### 2. Configuración

Docker Swarm
Luego de instalar docker en cada una de las máquinas donde éste se correrá, es
necesario configurar los managers y nodes que actuarán en el swarm . En el servidor

donde actuará el manager ejecutamos el siguiente comando:
```sh
docker swarm init
```
Para ingresar los workers al swarm digitamos en los correspondientes servidores el
comando que allí aparece, éste se encuentra de la forma docker swarm join --token
<token> <ip>:<port> .




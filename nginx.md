Este manual está basado en la documentación oficial: [nginx](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)


Nginx pronunciado "motor x" es un servidor de código abierto HTTP y proxy inverso de alto rendimiento responsable de manejar la carga de algunos de los sitios más grandes en Internet. Se puede usar como servidor web independiente, equilibrador de carga, caché de contenido y proxy inverso para servidores HTTP y no HTTP.

En comparación con Apache, Nginx puede manejar una gran cantidad de conexiones concurrentes y tiene una menor huella de memoria por conexión.

Este tutorial explica cómo instalar y administrar Nginx en CentOS 8.

***
### Prerequisitos:
  - Conocimientos básicos sobre Linux
  - Usuario Administrador del sistema
  - Conectividad a Internet
  - Acceso por consola a una instalación de CentOS 8



Antes de continuar, asegúrese de haber iniciado sesión como usuario con privilegios de sudo y de que no tenga Apache ni ningún otro proceso ejecutándose en el puerto 80 o 443.

***

### 1. Instalar Nginx

Ejecutar el siguiente comando:

```sh
sudo yum install nginx
```

### Iniciar servicio

Una vez completada la instalación, habilite e inicie el servicio Nginx con:
```sh
sudo systemctl enable nginx
```
```sh
sudo systemctl start nginx
```
Para verificar que el servicio se esté ejecutando, verifique su estado:
```sh
sudo systemctl status nginx
```
### 2. Ajuste del cortafuegos 

FirewallD es la solución de firewall predeterminada en Centos 8.

Durante la instalación, Nginx crea un archivo de servicio firewalld con reglas predefinidas para permitir el acceso a los puertos HTTP ( 80) y HTTPS ( 443).

Use los siguientes comandos para abrir los puertos necesarios permanentemente:

```sh
sudo firewall-cmd --permanent --zone=public --add-service=http
```

```sh
sudo firewall-cmd --permanent --zone=public --add-service=https
```
```sh
sudo firewall-cmd --reload
```

Ahora, puede probar su instalación de Nginx abriéndola http://YOUR_IPen su navegador web. Debería ver la página de bienvenida predeterminada de Nginx.



***
### 3. Configuración de nginx


Modificar el archivo de configuración de nginx, debe ingresar al siguiente archivo:
```sh
vi /etc/nginx/nginx.conf
```
Se debe cambiar la linea que contenga lo siguiente:

include /etc/nginx/conf.d/*.conf;

y cambiarla por:

include /etc/nginx/sites-enabled/*.conf;

### Configurar virtual host

Crear las siguientes carpetas con los siguientes comandos:

```sh
mdir /etc/nginx/sites-available/
```

```sh
mdir /etc/nginx/sites-enabled/
```
Crear archivo conf con el siguiente comando:
```sh
sudo vi /etc/nginx/sites-available/example.conf
```
Agregar el siguiente contenido al archivo:

    servidor {

        escucha 443;
        nombre_servidor ejemplo.com;

        root / usr / share / nginx / www;
        index index.html index.htm;

        ssl on;
        ssl_certificate /etc/nginx/ssl/example.com/server.crt;
        ssl_certificate_key /etc/nginx/ssl/example.com/server.key;
    }


Activar virtual host con el siguiente comando.
```sh
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
```
### 4. Configuración de SSL

Para configurar un servidor HTTPS, el sslparámetro debe estar habilitado en los zócalos de escucha en el bloque del servidor , y se deben especificar las ubicaciones del certificado del servidor y los archivos de clave privada.

Crear la carpeta contenedora de los certificados SSL con el siguiente comando:
```sh
mkdir -p /etc/nginx/ssl/example.com
```

Guardar los dos certificados en la ruta creada.

Y  por ultimo ejecutar el siguiente comando:
```sh
sudo service nginx restart
```





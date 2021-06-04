    VERSION 1.0.2

# MongoDB Install


Este es el manual de instalación de **MongoDB 4.2** Community Edition y la configuración de un Replica Set en **CentOS 8**. Los paquetes a ser instalados serán:

  - mongodb-org
  - mongodb-org-server
  - mongodb-org-mongos
  - mongodb-org-shell
  - mongodb-org-tools

El Replica Set a instalar consta de 3 nodos normales. Esta es la configuración mínima  recomendada para un Replica Set. Un replica set funciona con un nodo *principal* y el resto son nodos *secundarios*. Calquier nodo secundario eventualmente puede convertirse en el nodo principal. Por lo tanto las 3 nodos deben tener la misma capacidad de procesamiento y capacidad de disco.

Este manual está basado en la documentación oficial: [MongoDB](https://docs.mongodb.com/manual/installation/)  

***
### Prerequisitos:
  - Conocimientos básicos sobre Linux
  - Usuario Administrador del sistema
  - Conectividad a Internet
  - Acceso por consola a una instalación de CentOS 8

*NOTA: Los procedimientos enumerados en la [sección #1](#sistema-operativo) buscan configurar el sistema operativo para obtener el mayor desempeño posible en ambientes productivos con alta concurrencia. Sin embargo en ambientes de pruebas o incluso en ambientes productivos de baja concurrencia la instalación standard, en cualquier distribución de linux soportada, funciona satisfactoriamente.



***
## 1. Configuración Sistema operativo

Al momento de la instalación del sistema operativo, asegurarse de escoger que el `file system` sea [XFS](https://docs.mongodb.com/manual/administration/production-notes/#kernel-and-file-systems) . En CentOS 8 el file system por defecto es XFS. 

### Limitar SWAP memory  
El uso de memory swap afecta realmente el desempeño de MongoDB. El uso de SWAP memory debe limitarse solo para evitar problemas críticos de memoria del sistema:

Para verificar el valor actual:  

    cat /proc/sys/vm/swappiness  

Editar el archivo:  

    vi /etc/sysctl.conf

Y agregar la siguiente línea:

    vm.swappiness = 1
    
Guardar los cambios y ejecutar:  

    sudo sysctl -p


### Permitir conectividad remota
La siguiente configuración asume que los sevidores de MongoDB se encuentran dentro de una RED segura y solo pueden ser alcanzados por los servidores de aplicaciones. En cualquier otro caso, se recomienda usar una [configuración mas restrictiva](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/#configure-selinux) de `iptables|firewalld` y `selinux`.

En CentOS 8 existe un administrador de iptables llamado `firewalld`, sin embargo nuestro servidor no requiere este programa. Para desactivar firewalld ejecutar las siguientes comandos:
```sh
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```
En CentOS 8 el módulo de seguridad SELinux bloquea por defecto el acceso a la mayoría de los puertos. Para desactivar `selinux` ejecutar los siguientes comandos:
```sh
sudo vi /etc/selinux/config
```
Y cambiar la variable SELINUX a disabled:
```sh
SELINUX=disabled
```
Para verificar el estado:

    sestatus
    
Para que los cambios tomen efecto de `selinux`, será necesario reiniciar.

NOTA: El puerto por defecto para mongo es el `27017`.  

NOTA: Todos los nodos del replica set tienen que ser alcanzables entre ellos y por los servidores de aplicaciones.


### Configurar límites de procesamiento
Por defecto los sistemas operativos basados en UNIX restringen los límites de procesamiento a los usuarios cuando ejecutan procesos. Los límites más importantes a tener en cuenta son los siguientes:
  - `-f (file size): unlimited`
  - `-t (cpu time): unlimited`
  - `-v (virtual memory): unlimited`
  - `-l (locked-in-memory size): unlimited`
  - `-n (open files): 64000`
  - `-m (memory size): unlimited`
  - `-u (processes/threads): 64000`


Los sistemas operativos que usan `systemd` deben crear el archivo `/etc/systemd/system/[name of service].service.d/limits.conf` donde el nombre del servicio es `mongod`:

```sh
sudo mkdir /etc/systemd/system/mongod.service.d/
sudo vi /etc/systemd/system/mongod.service.d/limits.conf
```
Y agregar el siguiente contenido:
```
[Service]
LimitFSIZE=infinity
LimitCPU=infinity
LimitAS=infinity
LimitMEMLOCK=infinity
LimitNOFILE=64000
LimitNPROC=64000
```
Finalmente ejecutar:
```sh
sudo systemctl daemon-reload
```


### Inhabilitar Transparent Huge Pages (THP)
THP es una opción para configurar el manejo de la paginación de la memoria en Linux, sin embargo no es una opción recomendada para MongoDB. Para saber si esta opción está habilitada ejecutar el siguiente comando:
```sh
cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag
```
La opción seleccionada aparecerá dentro de `[ ]`. Para desactivar THP ejucutar el procedimiento a continuación:
```sh
sudo vi /etc/systemd/system/disable-transparent-huge-pages.service
```
y agregar lo siguiente:
```sh
[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=mongod.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/defrag > /dev/null'

[Install]
WantedBy=basic.target
```
Luego ejecutar:
```
sudo systemctl daemon-reload
sudo systemctl start disable-transparent-huge-pages
sudo systemctl enable disable-transparent-huge-pages
```

Si bien el script anterior desactiva THP,  CentOS 8 incluye un programa llamado `tuned` que puede volverlo a activar. Por lo tanto, también es necesario configuar *tuned*.

Crear el directorio y nuevo profile para tuned:
```sh
sudo mkdir /etc/tuned/virtual-guest-no-thp
sudo vi /etc/tuned/virtual-guest-no-thp/tuned.conf
```
Y agregar el siguiente contenido:
```
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
```
Finalmente ejecutar el siguiente comando para habilitar el nuevo profile:
```sh
sudo tuned-adm profile virtual-guest-no-thp
```



***
## 2. Instalar MongoDB
NOTA: Después de haber ejecutado los pasos de la sección 1, se recomienda reiniciar el Sistema Operativo.

Para poder instalar MongoDB 3.6 usando el package manager de RedHat/CentOS, se debe agregar el repositorio de MongoDB a YUM. Para esto, ejecutar los siguientes comandos:

Crear archivo de configuración:
```sh
sudo vi /etc/yum.repos.d/mongodb-org-4.2.repo
```
Y agregar el siguiente contenido al archivo.

```
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
```

Ejecutar los siguientes comandos:
```sh
sudo yum install -y mongodb-org-4.2.7 mongodb-org-server-4.2.7 mongodb-org-shell-4.2.7 mongodb-org-mongos-4.2.7 mongodb-org-tools-4.2.7
```

Para iniciar el Servicio:

    sudo systemctl start mongod
    
    
Una vez instalado MongoDB, el motor puede detenerse o reiniciarse con los siguientes comandos respectivamente:

```sh
sudo systemctl stop mongod
sudo systemctl restart mongod
```



***
## 3. Configuración MongoDB

### Crear super-usuario
Los roles por defecto mas relevantes en MongoDB son:
  - `read`
  - `readWrite` (usuario aplicación de una base de datos específica)
  - `dbAdmin` o `dbOwner` (usuario administrador de una base de datos específica)
  - `root` (super-usuario)

Ejecutar el comando `mongo` para acceder a la shell de MongoDB y ejecutar  los siguientes comandos dentro de la shell:
```js
> db.disableFreeMonitoring()

> use admin

> db.createUser({
    "user" : "<admin-user>",
    "pwd" : "<admin-password>",
    "roles" : [ { role: 'root', db: 'admin'} ]
})
```
Si bien, el comando anterior creó un usuario. La atenticación del motor no se encuentra habilitada por defecto.

NOTA: El comando `db.createUser` recibe otros argumentos en donde es posible entre otras cosas, restringir la IP desde donde se conecta el usuario.


### Activar la autenticación por defecto
MongoDB por defecto no requiere ningún tipo de autenticación. Claramente en ambiente productivo no se puede permitir esta configuración. Para activar la autenticación ejecutar el siguiente procedimiento:

Editar el archivo de configuración de MongoDB:
```sh
sudo vi /etc/mongod.conf
```
Agregar el siguiente contenido (Puede que la sección **security** ya exista):
```
security:
  authorization: enabled
```

Nota: Tener en cuenta que al acceder a la shell de mongo de manera local NO es necesario autenticarse, solo algunos comandos a ejecutados al interior de la shell requieren un usuario autenticado.


### Puerto por defecto e interfaz de red
El Puerto de despliegue por defecto de MongoDB es el `27017`, si se desea cambiar este puerto se puede editar el archivo `/etc/mongod.conf` y cambiar la variable **port** en la sección **net**. También bajo la sección **net** se puede cambiar la dirección de la interfaz de red por la que MongoDB va a aceptar conexiones (**bindIp**). Consultar estos valores con área encargada para devOps. Se recomienda la siguiente configuración:

```sh
net:
  port: 27017
  bindIp: 0.0.0.0
```
NOTA: El campo *bindIp* NO indica la IP desde donde acepta conexiones. Este campo hace referencia únicamente a la dirección de interfaz de red  por donde recibe conexiones. Para restringir conexiones remotas desde IPs específicas podría usar `iptables` o consulte el adminstrador de la RED de su datacenter.

Finalmente reiniciar MongoDB.
```sh
sudo systemctl restart mongod
```
NOTA: Si se ejecutaron todos los procedimientos de la sección #1, #2 y #3 no deberían aparecer warnings al entrar a la shell de MongoDB.

NOTA: En esta sección se activó la autenticación para MongoDB, por lo tanto todas las operaciones a partir de este momento requiren autenticación.

```sh
mongo -u <admin-user> -p <admin-password> admin
```
Otra manera de hacerlo es con `db.auth`:
```js
mongo
> db.auth('<admin-user>' , '<admin-password>')
```



***
## 4. Configuración Replica Set
Para esta sección se asume que MongoDB ya se encuentra instalado en los 3 servidores. La instalación standard es la misma para los nodos normales y el árbitro. También se asume que los 3 nodos son visibles entre si por el puerto configurado en la instalación.

El usuario administrador creado en la sección #3 restringe las operaciones dentro del motor de MongoDB, sin embargo, el usurio administrador no tiene nada que ver para la autenticación entre los miembros de un replica set. Para esto MongoDB permite dos tipos de autenticación con `KeyFiles` o certificados `x.509`. En este manual se indicará el procedimiento usando KeyFiles sin embargo para nodos distribuidos geográficamente, se recomienda el uso de certificados emitidos por un Certificate Authority (CA).

Ejecutar los siguientes comandos para generar el keyfile desde cualquier consola Linux, **este archivo debe ser generado una sóla vez y luego debe ser copiado en todos los nodos miembros del replica set**:

```sh
sudo su
openssl rand -base64 756 > /opt/keyfile
chown mongod:mongod /opt/keyfile
chmod 400 /opt/keyfile
exit
```
La ruta absoluta del archivo será `/opt/keyfile` (puede cambiarse). Si el comando openssl no está disponible, el archivo se puede generar de forma manual. El archivo no tiene nada en particular, sólo debe contener un STRING en base64 entre 6 y 1024 caracteres.

Es posible que después de otorgar los permisos, el usuario mongod aún no pueda acceder al keyfile y mongoDB no pueda iniciar. Se recomienda verificar que SELinux esté desactivado. (Ver sección #1)

Después de haber copiado el keyfile en los 3 nodos y haber cambiador los permisos, editar el archivo `/etc/mongod.conf` de cada nodo y agregar el siguiente contenido:

IMPORTANTE: Verificar que mongo esté detenido con `systemctl stop mongod`.
```sh
security:
  authorization: enabled
  keyFile: /opt/keyfile
replication:
  replSetName: "<myReplicaSetName>"
```
 - Donde `/opt/keyfile` es la ubicación del keyfile que se copió a cada nodo (Se puede cambiar la ubicación del archivo si se desea). 
 - `<myReplicaSetName>` es el nombre que va a identificar el replica set.
 - Notar también que `security.authorization` ya se había incluido en la sección #3. En los todos los nodos del replica set el valor para `replSetName` debe ser el mismo.


Al finalizar, reiniciar MongoDB en los 3 nodos:
```sh
sudo systemctl restart mongod
```

A continuación entrar a la shell de cualquiera de los nodos (sólo uno de los 3)  e iniciar el replica set con el comando `rs.initiate`, este comando recibe el JSON de configuración del replica set:

```js
rs.initiate( {
   _id : "myReplicaSetName",
   version: 1,
   members: [
      { _id: 0, host: "mongodb00.example.net:27017" },
      { _id: 1, host: "mongodb01.example.net:27017" },
  { _id: 2, host: "mongodb02.example.net:27017" }
   ]
})
```
Donde `mongodbXX.example.net:YYYYY` corresponde al dominio y puerto de cada uno de los nodos del replica set que estamos configurando. Se pueden usar direcciones IP a cambio de los dominios. El tercer miembro del replica set del ejemplo que tiene la propiedad `arbiterOnly` debería ser el servidor con menor capacidad.

NOTA: En caso de que algo salga mal configurando el réplica set, lo mejor es eliminar cualquier configuración previa con el siguiente procedimiento:

  - Detener MongoDB en los **todos** nodos del replica set.
  - Editar el archivo /etc/mongod.conf y comentarear las secciones 'security' y 'replication'
  - Reiniciar mongoDB en los nodos y eliminar la database `local`
  - Editar el archivo /etc/mongod.conf y descomentarear las secciones 'security' y 'replication'
  - Reiniciar MongoDB en todas las instancias.
  - Ejecutar `rs.initiate` como se indicó arriba.


***
## 5. Comandos básicos de diagnóstico del Replica Set

  - `rs.stepDown()` Se ejecuta sobre un nodo master. Le indica al replica set que se debe elegir un nuevo master. (este proceso puede tomar 30 segundos aproximadamente)
  - `rs.status()` Muestra el estado actual del replica set.
  - `rs.slaveOk()` Permite que hacer consultas sobre un nodo secundario.


***
## 6. Carga de Datos Iniciales para los Módulos.


Para agregar  usuarios de aplicación se puede usar el comando `db.createUser` usado tambíen en la sección #3 para la creación del usuario admin. Cuando MongoDB está corriendo en modo replica set la creación del usuario de aplicación deberá hacerse desde el nodo `master`.

Ejemplo:
```sh
mongo -u <admin-user> -p <admin-password> admin
> use <myDatabaseName>
> db.createUser({ "user" : "<new-user-name>", "pwd" : "<secret-password>", "roles" : [ { role: 'readWrite', db: '<myDatabaseName>'} ] })
```

Cuando MongoDB está trabajando en modo réplica set, el nodo master se encargará de crear el usuarios en los nodos secundarios.



## 7. Ejemplo de conexión al replica set desde cliente NodeJS

```js
const mongoose = require('mongoose')
//MONGODB CONNECTION
let db_host1 = process.env.MONGO_HOST1 || '192.168.86.55'
let db_port1 = process.env.MONGO_PORT1 || 27017
let db_host2 = process.env.MONGO_HOST2 || '192.168.86.28'
let db_port2 = process.env.MONGO_PORT2 || 27018

let db_user = process.env.MONGO_APP1_USER || 'user1'
let db_passwd = process.env.MONGO_APP1_PASSWD || 'aoeu'
let db_name = 'myDatabaseName'
let replica_set_name = 'myReplicaSetName'

let mongo_uri = 'mongodb://' + `${db_user}:${db_passwd}@`
mongo_uri += `${db_host1}:${db_port1}`
mongo_uri += `,${db_host2}:${db_port2}`
mongo_uri += '/' + db_name + '?'
mongo_uri += 'replicaSet=' + replica_set_name
console.log(mongo_uri)
let mongo_options = { poolSize: 10 }
mongoose.connect(mongo_uri, mongo_options).then((data)=>{
        console.log('CONNECTED')
        // API INIT
        app.listen( MS.port , ()=> console.log(MS) )
},
err => {
        console.log('ERROR')
        console.error(err)
        process.exit()
})
```







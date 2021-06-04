    VERSION 1.0.2

# Lineamientos MicroServicios (MS)

 - Un MS expone su API REST sobre HTTP (Stateless Requests).
 - Un MS debe tener alta cohesión y bajo acoplamiento.
 - Un MS debe ser compacto y en lo posible usar la menor cantidad de librerías externas.
 - Un MS tiene su propia base de datos.
 - Un MS puede llamar a otros microservicios.
 - Un MS debe tener su propio repositorio.
 - Un MS puede tener varias Instancias. Las instancias se crean y se destruyen constantemente. Por lo tanto los microservicios no deben usar el disco duro como medio de almacenamiento. Las rutinas como *cron-jobs* deben sincronizarce por la base de datos de microservicio.

En teoría los Microservicios pueden estar escritos en cualquier lenguaje de programación y pueden usar cualquier base de datos. Sin embargo para facilitar el despliegue y la mantenibilidad del sistema, se recomienda al desarrollador usar ***NODE JS*** y **MONGO DB** en lo posible. Al momento de escribir estos lineamientos las versiones disponibles son NODE 12LTS y MONGO 4.2. 

### Propiedades
Un microservcio debe tener las siguientes propiedades, todas los nombres de las propiededas deben contener Letras UPPERCASE o números. El único caracter separador de palabras debe ser "_", en resumen los nombres deben cumplir ```/^[A-Z][_A-Z0-9]*[A-Z0-9]$/```:
 `
 - **NAME**  *ms_< namespace >_< name >* (LOWERCASE) - Debe estar quemado en el microservicio. Y debe coincidir con el nombre del proyecto en el repositorio.
 - **VERSION** Debe estar quemado en el microservicio. Se recomienda usar un GIT HOOK que sobre-escriba los valores en cada commit, Documentar este proceso en el `README.md` del proyecto). Ejemplo:
 
```
    {
        NUMBER: <autoincrement>,
        COMMIT: <last-commit-hash>,
        DATE: <last-commit-date>
    }
```





### Variables de Entorno

 - **PORT** (NUMBER) El puerto por el que el microservicio aceptará conexiones.
 - **DEBUG** TRUE/FALSE (UPPERCASE) la aplicación debera transformarlo a Boolean.


Los microservicios que usen MONGO DB como base de datos interna deberán también recibir las siguientes variables:

 - **MONGODB_NAME** Nombre de la base de datos del MS.
 - **MONGODB_USER** Usuario de conexión a la base de datos del MS.
 - **MONGODB_PASSWORD** Contraseña de conexión a la base de datos del MS.
 - **MONGODB_HOST** Dominio o IP de conexión a las base de datos del MS.
 - **MONGODB_PORT** Puerto de conexión a la base de datos del MS.
 - **MONGODB_POOL_SIZE** (NUMBER) Tamaño del pool de conexiones a la base de datos.
 - **MONGODB_REPLICA_SET** Nombre del replica set de la base de datos del MS. Si esta variable de entorno no está definida, la conexión a MONGO deberá realizarce de manera normal.

Por supuesto cada microservicio podrá recibir cualquier otra cantidad de variables de entorno. Estas deberán estar documentadas en el `README.md` de cada proyecto.

NOTA: Por ningún motivo el desarrollador deberá definir variables de entorno por defecto. El ambiente de desarrollo deberá proveer al Microservicio las variables de entorno correspondientes. Este mecanismo deberá estar documentado en el `README.md` del proyecto.

### Endpoints
Todos los requests exitosos deben retornar `HTTP STATUS CODE 200`. Cualquier otro status code será catalogado como un error:

    Content-Type: application/JSON
    HTTP STATUS CODE == 200: { data: <RESPONSE> }

    Content-Type: application/JSON
    HTTP STATUS CODE == 500: { error:{
        rid: Request ID, 
        code: Error Code Number,
        trace: [ { NAME, VERSION, PORT, REQUEST.METHOD, REQUEST.endpoint }],
        details: any.
    }}

En este sentido no es necesario que todo error (`Exception`) se controle en tiempo de ejecución, pero si es necesario que se atrape (`CATCH`) y se retorne el error correspondiente. Cuando un Microservicio recibe una respuesta de error por parte de otro Microservicio, deberá agregar sus datos al final del arreglo `trace` y retornar la misma estructura.



Todos los microservicios deberán exponer los siguientes endpoints por defecto:

    GET / - Deberá responder únicamente HTTP STATUS CODE 200 sin BODY
    
    GET /info - { NAME, VERSION, PORT }
    
    * /api/<endpoint> - Servicios expuestos por el Microservicio.
    

NOTA: Cada endpoint del servicio  `/api/<endpoint>` debe estar definido en su propio archivo, clase o módulo.
    
### LOGS

Todos los microservcios deberán escribir logs por salida standard.  `standard output (stdout)` y `standard error (stderr)`.

 - Si el Microservicio tiene la variable de entorno `DEBUG=TRUE`. Se debe imprimir detalles del request como `HORA`, `METHOD`, `PATH`, `QUERY`, `HEADERS` y `BODY`. Y cualquier otro dato que el desarrollador considere útil para diagnosticar el comportamiento de la aplicación (***stdout***). También se debe imprimir los errores (***stderr***).
 - Si el Microservicio tiene la variable de entorno `DEBUG=FALSE` solamente se deben imprimir errores (***stderr***).
 

### HEADERS

El sistema cuenta con una serie de Microservicios filtros iniciales que se encargan de la autenticación y la authorización al resto de microservcios del sistema. Estos microservicios injectarán en los headers los siguientes headers.

 - `KTE_RID` Request Identifier
 - `KTE_UID` User Identifier

En caso de tener que llamar a otro microservicio, se deberan injectar estos headers en ese request de manera manual. Cada microservicio debe validar, registrar en sus transacciones internas (si aplica) e incluir en el log (DEBUG) estos parámetros.


### Estructura del Directorio del Proyecto

 - `README.md`
 - `.gitignore`
 - `/Dockerfile`
 - `/package.json`
 - `/src`
 - `/src/main.js`
 - `/src/endpoints`






    

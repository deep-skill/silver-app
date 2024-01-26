# Documentación del despliegue de la aplicación

## Archivo docker-compose.yaml

### Descripción general

    Este archivo define la configuración para desplegar la aplicación utilizando Docker Compose.
    Contiene la definición de los servicios de la aplicación:
        Nginx (servidor web)
        Node.js (API)
        PostgreSQL (base de datos)
    Define también los volúmenes para almacenar datos persistentes.

### Servicios

#### Nginx

    Contenedor: nginx
    Imagen: Construida a partir del Dockerfile en ./silver-app
    Puertos:
        443:443: Mapea el puerto 443 del contenedor al puerto 443 del host
    Volumenes:
        ./nginx/ssl:/etc/nginx/ssl: Monta el directorio ./nginx/ssl para los certificados SSL
        ./silver-app/build/web:/usr/share/nginx/html: Monta el directorio de la aplicación web
        ./nginx/nginx.conf:/etc/nginx/nginx.conf: Monta el archivo de configuración de Nginx
    Dependencias: Depende de los servicios node_app y db_api

#### Node.js

    Contenedor: silver-api
    Imagen: Construida a partir del Dockerfile en ./silver-api
    Puertos:
        3001:3001: Mapea el puerto 3001 del contenedor al puerto 3001 del host
    Variables de entorno:
        ENVIRONMENT: Define el entorno de la aplicación (p.ej., "development", "production")
        DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME: Variables de conexión a la base de datos
        PORT: Puerto en el que se ejecuta la API
        AUDIENCE, ISSUERBASEURL, TOKENSIGNINGALG: Variables relacionadas con la autenticación
    Dependencias: Depende del servicio db_api
    Restart: Siempre se reinicia si se detiene inesperadamente

#### PostgreSQL

    Contenedor: db-compose
    Imagen: postgres:14
    Puertos:
        5432:5432: Mapea el puerto 5432 del contenedor al puerto 5432 del host
    Variables de entorno:
        POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB: Variables de configuración de la base de datos
    Volumenes:
        db-compose_data:/var/lib/postgresql/data: Almacena los datos persistentes de la base de datos

### Volúmenes

    db-compose_data: Volumen para almacenar los datos persistentes de la base de datos

## Archivo de configuración de Nginx

### Descripción general

    Este archivo configura el servidor Nginx para servir la aplicación web y redirigir las solicitudes de la API a la aplicación Node.js.
    Escucha en el puerto 443 con SSL habilitado.
    Sirve los archivos estáticos de la aplicación web desde el directorio /usr/share/nginx/html.
    Redirige las solicitudes a la API a la aplicación Node.js que se ejecuta en el puerto 3001.

### Secciones principales

#### worker_processes

    Define el número de procesos de trabajo de Nginx. En este caso, se establece en 1.

#### events

    Configura cómo Nginx maneja las conexiones.
    worker_connections: Establece el número máximo de conexiones simultáneas que puede manejar cada proceso de trabajo.

#### http

    Contiene la configuración principal del servidor web.
    include mime.types: Incluye definiciones de tipos MIME para archivos estáticos.
    default_type: Establece el tipo MIME predeterminado para archivos no reconocidos.
    sendfile: Habilita la transferencia de archivos más eficiente.
    keepalive_timeout: Establece el tiempo que Nginx mantiene las conexiones inactivas abiertas.

#### server

    Define un bloque de servidor virtual.
    listen: Establece el puerto y protocolo en el que escucha el servidor.
    server_name: Establece el nombre de dominio para el que responde el servidor.
    ssl_certificate: Especifica la ruta al certificado SSL.
    ssl_certificate_key: Especifica la ruta a la clave privada SSL.
    ssl_protocols: Define los protocolos SSL permitidos.
    ssl_ciphers: Especifica los cifrados SSL permitidos.

#### location /silver-api/

    Configura la redirección de las solicitudes a la API.
    proxy_pass: Redirige las solicitudes a la aplicación Node.js que se ejecuta en el puerto 3001.

#### location / 

    Configura la entrega de archivos estáticos de la aplicación web.
    root: Especifica el directorio raíz donde se encuentran los archivos estáticos.
    index: Especifica los archivos de índice para las solicitudes a directorios.

#### error_page

    Define páginas de error personalizadas para códigos de estado HTTP específicos.

#### location = /50x.html

    Especifica la ubicación del archivo de error 50x.html.

## Dockerfile para la API

### Descripción general

    Este Dockerfile construye la imagen de Docker para la aplicación Node.js.
    Utiliza la imagen base node:18-alpine como punto de partida.

### Instrucciones principales

#### FROM

    Especifica la imagen base a partir de la cual se construirá la nueva imagen.

#### WORKDIR

    Establece el directorio de trabajo dentro del contenedor.

#### COPY package.json ./*

    Copia los archivos package.json y package-lock.json al directorio de trabajo.

#### RUN npm install

    Instala las dependencias de la aplicación Node.js.

#### COPY . .

    Copia el resto del código fuente de la aplicación al directorio de trabajo.

#### EXPOSE 3001

    Indica que el contenedor escuchará en el puerto 3001.

#### CMD ["npm", "start"]

    Comando predeterminado que se ejecutará al iniciar el contenedor. En este caso, ejecuta npm start para iniciar la aplicación Node.js.

## Despliegue independiente de la API

### Archivo docker-compose.yaml específico para la API

Si se desea desplegar únicamente la API, se puede utilizar el siguiente archivo docker-compose.yaml ubicado en la carpeta silver-api:

Descripción:

    Este archivo define dos servicios:
        node_app: Contiene la aplicación Node.js y la base de datos PostgreSQL.
        db_api: Contiene la base de datos PostgreSQL.

Servicios:

#### node_app

    Construye la imagen de Docker a partir del Dockerfile en la misma carpeta.
    Nombra el contenedor como node_app.
    Asigna el puerto 3001 del host al puerto 3001 del contenedor.
    Define variables de entorno para la conexión a la base de datos y otras configuraciones.
    Depende del servicio db_api.
    Siempre se reinicia si se detiene inesperadamente.

#### db_api

    Utiliza la imagen postgres:14.
    Nombra el contenedor como db-compose.
    Asigna el puerto 5432 del host al puerto 5432 del contenedor.
    Define variables de entorno para la configuración de la base de datos.
    Usa un volumen para almacenar los datos persistentes de la base de datos.

Volumenes:

    db-compose_data: Volumen para almacenar los datos persistentes de la base de datos.

Pasos para el despliegue de la API:

Navegar a la carpeta silver-api:

```sh
cd silver-api
```

Ejecutar docker-compose up:

```sh
docker-compose up -d
```


Con esto, se iniciarán los contenedores de la API y la base de datos, y la API estará disponible en el puerto 3001 del host.

## Despliegue de la APP, API y base de datos en local

### Archivo docker-compose.yaml específico para la APP

Si se desea desplegar únicamente la APP y API en local, se debe utilizar el archivo docker-compose.yaml ubicado en la carpeta silver-app:

Se necesita copiar el archivo en la raiz del proyecto que contenga ambas carpetas (silver-app y silver-api)

Una vez ubicado en la raiz ejecutar:

```sh
docker-compose up -d
```


Con esto, se iniciarán los contenedores de la APP, API y la base de datos, y la API estará disponible en el puerto 3001 del host.
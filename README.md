# Instrucciones

## Dependencias

**Linux**
- [NPM y Node](https://github.com/nvm-sh/nvm)
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/)

**Windows**
- [NPM y Node](https://nodejs.org/es/download)
- [Docker y Docker Compose](https://docs.docker.com/desktop/install/windows-install/)




## Creación de contenedor de MYSQL

**Ingresar a la carpeta mysql/db y ejecutar el comando:**

``` 
docker compose up -d    
```
**Para finalizar el contenedor, ejecutar en mysql/db:**
``` 
docker compose down  
```
**Datos de usuario root**
```


- name: root
- password: pass
```

- _Para modificar el password del usuario root se debe modificar la variable MYSQL_ROOT_PASSWORD en el archivo docker-compose.yml_

- _Para modificar el nombre de la base de datos se debe modificar la variable MYSQL_DATABASE en el archivo docker-compose.yml_

- _Si se desean agregar,quitar,modificar comandos SQL para que se ejecuten al crear el contenedor, estos deben ser agregados al archivo data.sql y sin comentarios_



## Ejecución de App

**Para usar la aplicación se deben de modificar las variables de entorno en el archivo .env en la carpeta mysql/app**

```
PORT=3000 (Puerto de la aplicación)
DB_HOST='IP DE LA BASE DE DATOS'
DATABASE='NOMBRE BASE DE DATOS'
DB_USER='NOMBRE DEL USUARIO'
DB_PASS='PASS DEL USUARIO'
DB_PORT=3306
```

**Si se crea el contenedor sin modificar nada entonces el único cambio necesario seria agregar la IP del host de la base de datos:**
```
PORT=3000 (Puerto de la aplicación)
DB_HOST='IP DE LA BASE DE DATOS' 
DATABASE='db'
DB_USER='root'
DB_PASS='pass'
DB_PORT=3306
```

**Para ejecutar la aplicación usar la siguiente instrucción:**
```
npm start
```





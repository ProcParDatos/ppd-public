# Environment P2 - Hadoop-MapReduce (Docker Compose) – x86_64 y ARM64 –

Este entorno se instala utilizando docker
Para obtener más información sobre docker (8 minutos en ingles) https://youtu.be/JSLpG_spOBM
En concreto usamos docker compose, una extensión de Docker que permite orquestación, es decir, definir y gestionar en un único archivo (docker-compose.yml)
varios servicios/contenedores, sus redes y volúmenes, para levantarlos y coordinarlos juntos con un solo comando.

A groso modo los pasos a realizar seran
Arrancar un cluster Hadoop virtual con `docker compose up`
Montar el sistema de ficheros Hadoop (HDFS) en tu máquina como si fuese una carpeta local (vía **HDFS NFS Gateway**).
De esta forma vas a poder trabajar con HDFS como si se tratase de una caja negra, simplemente como si se tratase de un disco mas.
Aun así lo podemos administrar a traves de la URI del NameNode, lanzar programas con MapReduce y gestionar YARN así como JobHistory

## Requisitos
- Docker Desktop o Docker Engine + Docker Compose plugin.
- Preferiblemente Linux, o Windows con WSL2 (igual que la práctica).
- Cliente NFS en el host (para montar la carpeta).

## 1) Arrancar el cluster

```bash

# Para arrancar el sistema HDFS
docker compose up -d --build


##### Comprobaciones para ver si está funcionando ####
```

UIs:
- HDFS NameNode: http://localhost:9870
- YARN RM: http://localhost:8088
- JobHistory: http://localhost:19888

# Comprobaciones NFS
nc -vz 127.0.0.1 2049
nc -vz 127.0.0.1 4242
docker compose exec nfsgateway id -u luser
docker compose exec nfsgateway id -g luser


## 2) Montar HDFS como carpeta local

Instala cliente NFS:
- Ubuntu/Debian: `sudo apt-get install nfs-common`
- Fedora/RHEL: `sudo dnf install nfs-utils`

# Monta (NFSv3, `nolock` recomendado por el gateway):

```bash

./mount-hdfs.sh mount

# Puedes ejecutar el siguiente script para comprobar que funciona correctamente
# Este script comprueba que hdfs este montado, crea un fichero de prueba,
# desmonta Hadoop, lo relanza y comprueba que el fichero siga existiendo

./test-hdfs.sh ~/hdfs

# Para desmontar completamente mas adelante ejecuta:
# sudo umount -l ~/hdfs
# o ./mount-hdfs.sh umount

```

A partir de aquí, todo lo que copies a `./hdfs` se guarda en HDFS dentro de `/user/luser` (export point).

## 4) Puedes Ejecutar comandos HDFS / YARN (sin administración extra)

Entra al contenedor “workbench”:

```bash
docker compose exec workbench bash
```

Ejemplos (equivalente a la practica):
```bash
export MAPRED_EXAMPLES=$HADOOP_HOME/share/hadoop/mapreduce
yarn jar $MAPRED_EXAMPLES/hadoop-mapreduce-examples-*.jar pi 16 1000
```

## Notas de seguridad
El NFS gateway está configurado para laboratorio local (hosts `*` y proxyuser `*`).


# Para detener el sistema HDFS
docker compose down

# Para borrar todos los contenedores y volumenes (se borrarán también los datos que hayas copiado a HDFS)
docker compose down --volumes --remove-orphans --rmi local

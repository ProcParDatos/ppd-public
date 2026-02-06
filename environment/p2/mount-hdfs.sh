#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/.env" ]; then
  set -a
  . "${SCRIPT_DIR}/.env"
  set +a
fi

: "${HDFS_MOUNT_USER:=luser}"
: "${HDFS_NFS_EXPORT:=/user/${HDFS_MOUNT_USER}}"

if [ "$#" -ne 1 ]; then
  echo "Uso: $(basename "$0") <mount|umount>"
  echo "Este script monta o desmonta siempre en \$HOME/hdfs."
  exit 1
fi

ACTION="$1"
if [ "${ACTION}" != "mount" ] && [ "${ACTION}" != "umount" ]; then
  echo "Accion invalida: ${ACTION}"
  echo "Uso: $(basename "$0") <mount|umount>"
  exit 1
fi

TARGET_USER="${SUDO_USER:-$(id -un)}"
TARGET_UID="$(id -u "${TARGET_USER}")"
TARGET_GID="$(id -g "${TARGET_USER}")"
TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"

if [ -z "${TARGET_HOME}" ]; then
  echo "No se pudo resolver el home para el usuario: ${TARGET_USER}"
  exit 1
fi

MOUNT_DIR="${TARGET_HOME}/hdfs"
EXPORT_PATH="${HDFS_NFS_EXPORT}"

if [ "${ACTION}" = "mount" ]; then
  if [ "$(id -u)" -eq 0 ]; then
    install -d -m 755 -o "${TARGET_UID}" -g "${TARGET_GID}" "$MOUNT_DIR"
  else
    mkdir -p "$MOUNT_DIR"
  fi

  echo "Montando HDFS (vía NFS) en: $MOUNT_DIR"
  echo "Export: ${EXPORT_PATH}"
  echo "Necesitas nfs-common (Debian/Ubuntu) o nfs-utils (Fedora/RHEL)."
  echo

  mount -t nfs -o nfsvers=3,proto=tcp,mountproto=tcp,port=2049,mountport=4242,nolock,noacl,soft,timeo=2,retrans=2 127.0.0.1:"${EXPORT_PATH}" "$MOUNT_DIR"

  echo
  echo "OK. Prueba: ls -la $MOUNT_DIR"
  echo "Para desmontar: $(basename "$0") umount"
  exit 0
fi

echo "Desmontando HDFS en: $MOUNT_DIR"
if mountpoint -q "${MOUNT_DIR}" 2>/dev/null; then
  umount "${MOUNT_DIR}"
  echo "OK. Desmontado: ${MOUNT_DIR}"
else
  echo "Nada que desmontar: ${MOUNT_DIR} no esta montado."
fi

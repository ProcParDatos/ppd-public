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

MOUNT_DIR="${1:-./hdfs}"
EXPORT_PATH="${2:-${HDFS_NFS_EXPORT}}"

mkdir -p "$MOUNT_DIR"

echo "Montando HDFS (vía NFS) en: $MOUNT_DIR"
echo "Export: ${EXPORT_PATH}"
echo "Necesitas nfs-common (Debian/Ubuntu) o nfs-utils (Fedora/RHEL)."
echo

sudo mount -t nfs -o nfsvers=3,proto=tcp,mountproto=tcp,port=2049,mountport=4242,nolock,noacl,soft,timeo=2,retrans=2 127.0.0.1:"${EXPORT_PATH}" "$MOUNT_DIR"

echo
echo "OK. Prueba: ls -la $MOUNT_DIR"
echo "Para desmontar: sudo umount $MOUNT_DIR"

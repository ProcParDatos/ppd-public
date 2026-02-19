#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/.env" ]; then
  set -a
  . "${SCRIPT_DIR}/.env"
  set +a
fi

TARGET_PATH="${1:-/}"
RECOVER_RETRIES="${2:-5}"
NAMENODE_SERVICE="${HDFS_RECOVERY_NAMENODE_SERVICE:-namenode}"
HDFS_SUPERUSER="${HDFS_RECOVERY_SUPERUSER:-hdadmin}"
COMPOSE=(docker compose -f "${SCRIPT_DIR}/docker-compose.yml")

usage() {
  echo "Uso: $(basename "$0") [hdfs_path] [reintentos]"
  echo
  echo "Ejemplos:"
  echo "  ./$(basename "$0")"
  echo "  ./$(basename "$0") /user/luser"
  echo "  ./$(basename "$0") /user/luser/libros 8"
}

if [ "${TARGET_PATH}" = "-h" ] || [ "${TARGET_PATH}" = "--help" ]; then
  usage
  exit 0
fi

if ! [[ "${RECOVER_RETRIES}" =~ ^[0-9]+$ ]] || [ "${RECOVER_RETRIES}" -lt 1 ]; then
  echo "Valor invalido de reintentos: ${RECOVER_RETRIES}"
  usage
  exit 2
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "No se encontro el comando docker."
  exit 2
fi

list_open_files() {
  local list_cmd
  printf -v list_cmd "hdfs dfsadmin -listOpenFiles -path %q" "${TARGET_PATH}"

  "${COMPOSE[@]}" exec -T "${NAMENODE_SERVICE}" su - "${HDFS_SUPERUSER}" -c "${list_cmd}" \
    | awk -F'\t' '
      NR > 1 {
        path = $NF
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", path)
        if (path ~ /^\//) print path
      }
    '
}

run_recover_lease() {
  local path="$1"
  local recover_cmd
  printf -v recover_cmd "hdfs debug recoverLease -path %q -retries %q" "${path}" "${RECOVER_RETRIES}"

  "${COMPOSE[@]}" exec -T "${NAMENODE_SERVICE}" su - "${HDFS_SUPERUSER}" -c "${recover_cmd}"
}

echo "Buscando ficheros abiertos bajo: ${TARGET_PATH}"
mapfile -t open_files < <(list_open_files)

if [ "${#open_files[@]}" -eq 0 ]; then
  echo "No hay ficheros abiertos pendientes."
  exit 0
fi

echo "Se detectaron ${#open_files[@]} fichero(s) abierto(s)."
recovered=0
failed=0

for path in "${open_files[@]}"; do
  echo
  echo "Recuperando lease: ${path}"
  if output="$(run_recover_lease "${path}" 2>&1)"; then
    echo "${output}"
    if printf '%s\n' "${output}" | grep -qi "recoverLease returned true"; then
      recovered=$((recovered + 1))
    elif printf '%s\n' "${output}" | grep -qi "recoverLease returned false"; then
      failed=$((failed + 1))
    else
      # Comportamiento inesperado: se revalida en el resumen final.
      :
    fi
  else
    echo "${output}"
    failed=$((failed + 1))
  fi
done

echo
echo "Revalidando leases abiertas..."
mapfile -t remaining_files < <(list_open_files)

if [ "${#remaining_files[@]}" -eq 0 ]; then
  echo "OK. No quedan ficheros abiertos."
  echo "Resumen: detectados=${#open_files[@]}, recuperados=${recovered}, fallidos=${failed}"
  exit 0
fi

echo "Quedan ${#remaining_files[@]} fichero(s) abierto(s):"
printf ' - %s\n' "${remaining_files[@]}"
echo "Resumen: detectados=${#open_files[@]}, recuperados=${recovered}, fallidos=${failed}"
exit 1

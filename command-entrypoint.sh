#!/bin/bash
echo "Waiting for database ..."

set -eo pipefail

if [[ -n "$POSTGRES_HOST" ]]; then
  host="$POSTGRES_HOST"
else
  host="$(hostname -i || echo '127.0.0.1')"
fi
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

args=(
        # force postgres to not use the local unix socket (test "external" connectibility)
        --host "$host"
        --username "$user"
        --dbname "$db"
        --quiet --no-align --tuples-only
)

while ! select="$(echo 'SELECT 1' | psql "${args[@]}")" || [ "$select" != '1' ]; do
    echo "sleeping ..."
    sleep 1
done

echo "Got database ... running command ..."

exec "$@"

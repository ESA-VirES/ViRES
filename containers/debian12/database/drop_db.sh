#!/bin/bash
#
# Simple script dropping PosgreSQL database

[ -z "$1" ] && {
    echo "USAGE `basename $0` <db-name>"
    exit 1
} 2>&1

info() {
  echo "INFO: $*" >&2
}

warn() {
  echo "WARNING: $*" >&2
}

error() {
  echo "ERROR: $*" >&2
  exit 1 
}

remove_db() {
    # deleting an existing database
    TMP=`psql -tAc "SELECT 1 FROM pg_database WHERE datname = '$DBNAME' ;"`
    if [ 1 == "$TMP" ]
    then
      # terminate connections before dropping the database
      psql -q -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DBNAME' ;" >/dev/null \
        && psql -q -c "DROP DATABASE $DBNAME ;" \
        && info "The existing database '$DBNAME' was removed." >&2 \
        || error "Failed to remove the existing database '$DBNAME'."
    else
      warn "The '$DBNAME' database does not exist."
    fi
}

clear_db_access() {
    # remove any DB-specific access restrictions
    PG_HBA="$PGDATA/pg_hba.conf"
    { ed -vs "$PG_HBA" || /bin/true ; } <<END
g/^\s*local\s*$DBNAME/d
g/^\s*host\s*$DBNAME/d
wq
END
    psql -q -c "SELECT pg_reload_conf();" >/dev/null
}

DBNAME="$1"

remove_db
clear_db_access

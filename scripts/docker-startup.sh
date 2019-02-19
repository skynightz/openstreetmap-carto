#!/bin/sh

# This script is used to start the import of kosmtik containers for the Docker development environment.
# You can read details about that in DOCKER.md

# Testing if database is ready

until pg_isready > /dev/null 2>&1; do
  echo "Waiting for postgres server..." 
  sleep 1
done

>&1 echo "Postgres server is up !"

case "$1" in
import)
  # Creating default database
  psql -c "SELECT 1 FROM pg_database WHERE datname = 'gis';" | grep -q 1 || createdb gis && \
  psql -d gis -c 'CREATE EXTENSION IF NOT EXISTS postgis;' && \
  psql -d gis -c 'CREATE EXTENSION IF NOT EXISTS hstore;' && \

  # Creating default import settings file editable by user and passing values for osm2pgsql
  if [ ! -e ".env" ]; then
    cat > .env <<EOF
# Environment settings for importing to a Docker container database
PG_WORK_MEM=${PG_WORK_MEM:-128MB}
PG_MAINTENANCE_WORK_MEM=${PG_MAINTENANCE_WORK_MEM:-2GB}
OSM2PGSQL_CACHE=${OSM2PGSQL_CACHE:-2048}
OSM2PGSQL_NUMPROC=${OSM2PGSQL_NUMPROC:-4}
OSM2PGSQL_DATAFILE=${OSM2PGSQL_DATAFILE:-data.osm.pbf}
EOF
    chmod a+rw .env
    export OSM2PGSQL_CACHE=${OSM2PGSQL_CACHE:-2048}
    export OSM2PGSQL_NUMPROC=${OSM2PGSQL_NUMPROC:-4}
    export OSM2PGSQL_DATAFILE=${OSM2PGSQL_DATAFILE:-data.osm.pbf}
  fi

  # Importing data to a database
  osm2pgsql \
  --cache $OSM2PGSQL_CACHE \
  --number-processes $OSM2PGSQL_NUMPROC \
  --hstore \
  --multi-geometry \
  --database gis \
  --slim \
  --drop \
  --style openstreetmap-carto.style \
  --tag-transform-script openstreetmap-carto.lua \
  $OSM2PGSQL_DATAFILE
  ;;

kosmtik)
  # Downloading needed shapefiles
  python scripts/get-shapefiles.py -n

  # Creating default Kosmtik settings file
  if [ ! -e ".kosmtik-config.yml" ]; then
    cp /tmp/.kosmtik-config.yml .kosmtik-config.yml  
  fi
  export KOSMTIK_CONFIGPATH=".kosmtik-config.yml"

  # Starting Kosmtik
  kosmtik serve project.mml --host 0.0.0.0
  # It needs Ctrl+C to be interrupted
  ;;

esac

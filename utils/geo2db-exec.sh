#!/bin/sh

if [ "$EXECSTATE"!="1" ]; then
    echo "Data Load Event Triggered"
    echo `date`
    export EXECSTATE=1
    for file in /data/*.gpkg /data/*.geojson; do
        echo "loading $file"
        ogr2ogr -f PostgreSQL \
        "PG:host=db port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} dbname=${POSTGRES_DB}" \
        -lco overwrite=yes \
        -lco skipfailures=yes \
        -lco schema=geodata \
        "$file"
    done
    export EXECSTATE=0
fi

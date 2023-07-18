#!/bin/bash

set -e

# Create the db admin user role
PGPASSWORD=${POSTGRES_PASSWORD} psql --username "supabase_admin" \
 --dbname "postgres" <<-EOSQL
CREATE ROLE ${DBUNM} WITH LOGIN SUPERUSER PASSWORD '${DBUPW}';
EOSQL

# Create the template db
PGPASSWORD=${POSTGRES_PASSWORD} psql --username "supabase_admin" \
 --dbname "postgres" <<-EOSQL
CREATE DATABASE template_db IS_TEMPLATE true;
EOSQL

# Load PostGIS and additional extensions into template_db
PGPASSWORD=${POSTGRES_PASSWORD} psql --username "supabase_admin" \
 --dbname "template_db" <<-EOSQL
	CREATE EXTENSION IF NOT EXISTS postgis;
	CREATE EXTENSION IF NOT EXISTS postgis_topology;
	-- Reconnect to update pg_setting.resetval
	-- See https://github.com/postgis/docker-postgis/issues/288
	\c
	CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
	CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
	CREATE EXTENSION IF NOT EXISTS pgrouting;
	CREATE EXTENSION IF NOT EXISTS pgtap;
	CREATE EXTENSION IF NOT EXISTS vector;
	CREATE EXTENSION IF NOT EXISTS pg_hashids;
	CREATE EXTENSION IF NOT EXISTS rum;
	-- CREATE EXTENSION IF NOT EXISTS http;
	-- CREATE EXTENSION pljava;
	-- GRANT USAGE ON LANGUAGE java TO PUBLIC;
	-- CREATE EXTENSION IF NOT EXISTS plv8;
EOSQL

# Create the dbdata database
PGPASSWORD=${POSTGRES_PASSWORD} psql --username "supabase_admin" \
 --dbname "postgres" <<-EOSQL
CREATE DATABASE dbdata WITH OWNER = '${DBUNM}' ENCODING 'UTF8' TEMPLATE template_db;
EOSQL

# Create the geodata schema in dbdata
PGPASSWORD=${DBUPW} psql --username "${DBUNM}" \
 --dbname "dbdata" <<-EOSQL
CREATE SCHEMA IF NOT EXISTS geodata;
EOSQL

# Copy the SRS table to the geodata schema
PGPASSWORD=${DBUPW} psql --username "${DBUNM}" \
 --dbname "dbdata" <<-EOSQL
CREATE TABLE geodata.spatial_ref_sys (LIKE public.spatial_ref_sys INCLUDING ALL);
INSERT INTO geodata.spatial_ref_sys
SELECT * FROM public.spatial_ref_sys;
EOSQL

# Create the mlflow database
PGPASSWORD=${POSTGRES_PASSWORD} psql --username "supabase_admin" \
 --dbname "postgres" <<-EOSQL
CREATE DATABASE mlflow WITH OWNER = '${DBUNM}' ENCODING 'UTF8' TEMPLATE template_db;
EOSQL

# Create the notebook user and set permissions
PGPASSWORD=${DBUPW} psql --username "${DBUNM}" \
 --dbname "dbdata" <<-EOSQL
-- Create non-superuser role
CREATE ROLE ${NBUNM} WITH LOGIN PASSWORD '${NBUPW}';
GRANT ALL PRIVILEGES ON DATABASE "dbdata" to ${NBUNM};
GRANT pg_read_all_data TO ${NBUNM};
GRANT pg_write_all_data TO ${NBUNM};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${NBUNM};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${NBUNM};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON TABLES TO ${NBUNM};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON SEQUENCES TO ${NBUNM};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA geodata TO ${NBUNM};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA geodata TO ${NBUNM};
ALTER DEFAULT PRIVILEGES IN SCHEMA geodata
  GRANT ALL PRIVILEGES ON TABLES TO ${NBUNM};
ALTER DEFAULT PRIVILEGES IN SCHEMA geodata
  GRANT ALL PRIVILEGES ON SEQUENCES TO ${NBUNM};
EOSQL

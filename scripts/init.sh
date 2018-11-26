#!/bin/bash

psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | \
	grep -q 1 || \
	psql -U postgres -c "CREATE DATABASE $POSTGRES_DB"

psql --user "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
	-v schema="$POSTGRES_DB" -v user="$POSTGRES_USER" -f /init-sql/init_db.sql
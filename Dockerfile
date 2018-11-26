FROM postgres:latest
RUN mkdir /init-sql
COPY sql/*.sql /init-sql/

COPY scripts/init.sh /docker-entrypoint-initdb.d/
UNAME_S := $(shell uname -s)

MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(dir $(realpath $(MKFILE_PATH)))
CURRENT_DIR := $(CURRENT_DIR:/=)
TODAY = $(shell date +%Y-%m-%d.%H:%M:%S)
TAG_DATE = $(shell date +%Y%m%d)

DOCKER_DB_USER := "msgr"
DOCKER_DB_NAME := "msgr"
DOCKER_DB_PORT := "5439"

DOCKER_DB_CONTAINER := "msgr-db"
DOCKER_DB_VOLUME    := "msgr-db_pgdata"
DOCKER_DB_IMAGE     := "msgr-db_db"

DOCKER := $(shell command -v docker 2> /dev/null)
PSQL   := $(shell command -v psql 2> /dev/null)

DEV_COMPOSE_FILE  := docker-compose.yml
TEST_COMPOSE_FILE := docker-compose.test.yml
PROD_COMPOSE_FILE := docker-compose.prod.yml


check_docker:
ifndef DOCKER
	$(error "You need to install Docker. https://store.docker.com/search?type=edition&offering=community")
endif

check_psql: 
ifndef PSQL
	$(error "You need to install PSQL. http://postgresapp.com/")
endif

build-img: check_docker
	@docker build -t $(DOCKER_DB_IMAGE) .

build: check_docker
	@docker-compose up --build

run: check_docker
	@docker-compose up -d

up: check_docker
	@docker-compose up -d

down: check_docker
	@docker-compose down

logs: check_docker
	@docker-compose logs -f

build-test: check_docker
	@docker-compose -f $(TEST_COMPOSE_FILE) up --build

up-test: check_docker
	@docker-compose -f $(TEST_COMPOSE_FILE) up -d

down-test: check_docker
	@docker-compose -f $(TEST_COMPOSE_FILE) down

logs-test: check_docker
	@docker-compose -f $(TEST_COMPOSE_FILE) logs -f

build-prod: check_docker
	@docker-compose -f $(PROD_COMPOSE_FILE) up --build

up-prod: check_docker
	@docker-compose -f $(PROD_COMPOSE_FILE) up -d

down-prod: check_docker
	@docker-compose -f $(PROD_COMPOSE_FILE) down

logs-prod: check_docker
	@docker-compose -f $(PROD_COMPOSE_FILE) logs -f

# utility commands
purge: check_docker
	@docker-compose down
	@docker volume rm $(DOCKER_DB_VOLUME)
	@docker rmi $(DOCKER_DB_IMAGE)

connect: check_psql
	@psql -h localhost -p $(DOCKER_DB_PORT) -U $(DB_USER)

fixtures: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -p $(DOCKER_DB_PORT) -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/fixtures.sql"

drop-tables: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -p $(DOCKER_DB_PORT) -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/drop_all_tables.sql"

init-db: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -p $(DOCKER_DB_PORT) -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/init_db.sql"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: run, build, up, down, logs, up-prod, down-prod, logs-prod, build-prod, up-test, down-test, logs-test, build-test list-containers, connect, help, fixtures, drop-tables, init-db
.DEFAULT_GOAL := help
#### BEGIN CONFIGURATION ##################################
# This is the project name used between this DB repo and
# anything that connects to it (API repo).
PROJECT_NAME := "messenger"

# Make sure these match the ones in the .env file!
DOCKER_DB_USER := "msgr"
DOCKER_DB_NAME := "msgr"
DOCKER_DB_PORT := "5439"

DOCKER_DB_CONTAINER := "$(PROJECT_NAME)-db"
DOCKER_DB_VOLUME    := "$(PROJECT_NAME)-db_pgdata"
DOCKER_DB_IMAGE     := "$(PROJECT_NAME)-db_db"

DOCKER := $(shell command -v docker 2> /dev/null)
PSQL   := $(shell command -v psql 2> /dev/null)

DEV_COMPOSE_FILE  := docker-compose.yml
TEST_COMPOSE_FILE := docker-compose.test.yml
PROD_COMPOSE_FILE := docker-compose.prod.yml
#### END CONFIGURATION ###################################

# Utility...
UNAME_S := $(shell uname -s)
MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(dir $(realpath $(MKFILE_PATH)))
CURRENT_DIR := $(CURRENT_DIR:/=)
TODAY = $(shell date +%Y-%m-%d.%H:%M:%S)
TAG_DATE = $(shell date +%Y%m%d)

#### TARGETS ---------------------------------------------
check_docker:
ifndef DOCKER
	$(error "You need to install Docker. https://store.docker.com/search?type=edition&offering=community")
endif

# In case you want to connect from psql locally...
check_psql: 
ifndef PSQL
	$(error "You need to install PSQL. http://postgresapp.com/")
endif

# Development Targets
build-img: check_docker
	@docker build -t $(DOCKER_DB_IMAGE) .

build: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose up --build

run: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose up -d

up: run

down: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose down

logs: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose logs -f


# Test Targets
build-test: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(TEST_COMPOSE_FILE) up --build

run-test: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(TEST_COMPOSE_FILE) up -d

up-test: run-test

down-test: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(TEST_COMPOSE_FILE) down

logs-test: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(TEST_COMPOSE_FILE) logs -f


# Production Targets
build-prod: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(PROD_COMPOSE_FILE) up --build

run-prod: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(PROD_COMPOSE_FILE) up -d

up-prod: run-prod

down-prod: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(PROD_COMPOSE_FILE) down

logs-prod: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose -f $(PROD_COMPOSE_FILE) logs -f

# utility commands
purge: check_docker
	@PROJECT_NAME=$(PROJECT_NAME) docker-compose down
	@docker volume rm $(DOCKER_DB_VOLUME)
	@docker rmi $(DOCKER_DB_IMAGE)

# Replaced this target that requires postgres to be installed
# locally with the pure docker one below.
#connect: check_psql
#	@psql -h localhost -p $(DOCKER_DB_PORT) -U $(DB_USER)

# Local development convenience targets
connect:
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME)"

fixtures: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/fixtures.sql"

drop-tables: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/drop_all_tables.sql"

init-db: check_docker
	@docker exec -it $(DOCKER_DB_CONTAINER) /bin/bash -c "psql -h 127.0.0.1 -U $(DOCKER_DB_USER) -d $(DOCKER_DB_NAME) -f /init-sql/init_db.sql"

reset-db: check_docker drop-tables init-db fixtures

.PHONY: build-img, build, run, up, down, logs, build-test, run-test, up-test, down-test, logs-test, build-prod, run-prod, up-prod, down-prod, logs-prod, purge, connect, fixtures, drop-tables, init-db, reset-db
.DEFAULT_GOAL := up
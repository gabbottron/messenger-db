# messenger-db
The relational db for the messenger API

**REQUIREMENTS**
- You must have [Docker](https://www.docker.com/) installed and running
- You must have a .env file in project root (see below)

## Standard dev configuration (.env file)
```
POSTGRES_USER=msgr
POSTGRES_PASSWORD={{YOUR_PASSWORD_HERE}}
POSTGRES_DB=msgr
```
## To start the database in a container
make up

## To stop the database container
make down

## To reset the database (must be running)
make reset-db

## To connect to the database (must be running)
make connect


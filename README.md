# messenger-db
The relational db for the messenger API

**Requirements:** Docker and PSQL

After you check out the project, create a .env file in the root and define the following 3 variables:
```
POSTGRES_USER=msgr
POSTGRES_PASSWORD={{YOUR_PASSWORD_HERE}}
POSTGRES_DB=msgr
```
At this point you should be able to run: make up

To reset the db: sql/reset_db

If you don't like to type your password:
```
export PGPASSWORD=yourpasshere
```

To connect to the database:
```
psql -h localhost -p 5439 -U msgr
```
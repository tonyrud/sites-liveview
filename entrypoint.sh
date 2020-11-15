#!/bin/bash
# Docker entrypoint script.
# Runs in phoenix container

# Wait until Postgres is ready
while ! pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

echo "postgres is up - checking for database $POSTGRES_DB"

GET_DB=$(PGPASSWORD=$POSTGRES_PASSWORD psql --user=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT -lqtA | grep -w $POSTGRES_DB)
# Create, migrate, and seed database if it doesn't exist.
if [ -z  $GET_DB ]
then
  echo "Database $POSTGRES_DB does not exist. Creating..."
  
  mix ecto.setup
else
  echo "Database $POSTGRES_DB has already been created"
fi

elixir --sname demo --cookie abc -S mix phx.server
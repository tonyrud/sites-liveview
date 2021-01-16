#!/bin/bash

# Here you can run migrations, db creation, seeds.
# This will run in the build spec, before a deployment is pushed to an ECS instance

docker run \
-e POSTGRES_USER=$POSTGRES_USER \
-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
-e POSTGRES_DB=$POSTGRES_DB \
-e POSTGRES_HOST=$POSTGRES_HOST \
-e SECRET_KEY_BASE=$SECRET_KEY_BASE \
-e HOST=$HOST \
--rm $REPOSITORY_URI \
bin/demo eval Demo.Release.setup

# Run seeds
# docker run \
# -e POSTGRES_USER=$POSTGRES_USER
# -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD
# -e POSTGRES_DB=$POSTGRES_DB
# -e POSTGRES_HOST=$POSTGRES_HOST
# -e SECRET_KEY_BASE=$SECRET_KEY_BASE \
# -e HOST=$HOST \
# --rm $REPOSITORY_URI \
# bin/demo eval 'Demo.Release.seed(Elixir.Demo.Repo, "seeds.exs")'


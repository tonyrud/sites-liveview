#!/bin/bash

: '
Run seeds locally at the moment. 
This requires the envs defined in an .envrc file, if using direnv library

Note: SECRET_KEY_BASE and HOST are necessary for the release to run, but not 
needed for the db seed to execute.
'
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 326347646211.dkr.ecr.us-east-2.amazonaws.com

IMAGE=$REPOSITORY_URI:latest
docker pull $IMAGE

# required to run release, but not needed for db seeding
docker run \
--rm \
-e POSTGRES_USER=$POSTGRES_USER \
-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
-e POSTGRES_DB=$POSTGRES_DB \
-e POSTGRES_HOST=$POSTGRES_HOST \
-e SECRET_KEY_BASE="" \
-e HOST="" \
 $IMAGE \
bin/demo eval 'Demo.Release.seed(Elixir.Demo.Repo, "seeds.exs")'

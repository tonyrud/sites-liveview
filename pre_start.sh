#!/bin/bash

: '
Here we run db creation and migrations.
This will run in the action, before a deployment
is pushed to an ECS instance.

Note the env vars below must be define in the Action.
'

docker run \
--rm \
-e POSTGRES_USER=$POSTGRES_USER \
-e POSTGRES_PASSWORD=eyZtJ2Ezq44BgxdozEcoD2tW \
-e POSTGRES_DB=$POSTGRES_DB \
-e POSTGRES_HOST=sites-liveview-app.cboyutsndpm0.us-east-2.rds.amazonaws.com \
-e SECRET_KEY_BASE="" \
-e HOST="" \
$FULL_IMG_PATH \
bin/demo eval Demo.Release.setup

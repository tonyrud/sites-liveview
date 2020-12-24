#!/bin/bash

docker run \
-e DATABASE_URL=$DATABASE_URL \
-e SECRET_KEY_BASE=$SECRET_KEY_BASE \
-e HOST=$HOST \
--rm $REPOSITORY_URI \
bin/demo eval Demo.Release.setup
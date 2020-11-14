FROM elixir:1.11-alpine

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache --virtual build-dependencies build-base && \
  apk add --no-cache postgresql && \
  apk add --no-cache inotify-tools && \
  apk add postgresql-client && \
  # necessary for live view locally
  apk add --no-cache nodejs npm openssh-client

COPY . /app
WORKDIR /app

RUN ["chmod", "700", "./entrypoint.sh"]

RUN mix do local.hex --force, \
  local.rebar --force, \
  deps.get, \
  compile, \
  phx.digest

RUN npm install --prefix assets

ENTRYPOINT ["sh", "./entrypoint.sh"]
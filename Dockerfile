FROM elixir:1.13.4-otp-25-alpine

ENV MIX_ENV=dev

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache --virtual build-dependencies build-base && \
  # apk add --no-cache postgresql && \
  apk add --no-cache inotify-tools && \
  apk add --no-cache postgresql-client && \
  # necessary for live view locally
  apk add --no-cache nodejs npm openssh-client && \
  mix local.rebar --force && \
  mix local.hex --force

WORKDIR /app


# Elixir Dependencies
COPY mix.exs .
COPY mix.lock .
RUN mix deps.get

# JS Dependencies
COPY /assets/package*.json ./assets/
RUN npm install --prefix assets && npm cache clean --force

COPY . .

RUN ["chmod", "700", "./entrypoint.sh"]

RUN mix compile

ENTRYPOINT ["sh", "./entrypoint.sh"]
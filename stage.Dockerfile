FROM elixir:1.11.3-alpine AS build

# prepare build dir
WORKDIR /app

RUN apk add --no-cache npm && \
  mix local.hex --force && \
  mix local.rebar --force

# JS dependencies
COPY /assets/package*.json ./assets/
RUN npm --version
RUN npm install --prefix assets && npm cache clean --force

# Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile


# ------------------------------
#  Releases
# ------------------------------
FROM build as release

ENV MIX_ENV=prod

# install build dependencies
RUN apk add --no-cache build-base git python3 erlang-observer

COPY config config

# Clean node deps install
RUN rm -rf ./assets/node_modules
RUN npm ci --prefix ./assets --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=release --chown=nobody:nobody /app/_build/prod/rel/demo ./

ENV HOME=/app

CMD ["bin/demo", "start"]

# ------------------------------
#  Local Development
# ------------------------------
FROM build as develop

ENV MIX_ENV=dev

# Install build dependencies
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache --virtual build-dependencies build-base && \
  # apk add --no-cache postgresql && \
  apk add --no-cache inotify-tools && \
  apk add --no-cache postgresql-client && \
  # necessary for live view locally
  apk add --no-cache nodejs openssh-client

COPY . .

RUN ["chmod", "700", "./entrypoint.sh"]

RUN mix compile

ENTRYPOINT ["sh", "./entrypoint.sh"]

# ------------------------------
#  CI
# ------------------------------
FROM build as ci

ENV MIX_ENV=test

COPY . .

RUN mix compile

# RUN mkdir -p priv/plts

# mix dialyzer
# # Create the dialyxir directory if it doesn't already exist
# mkdir -p dialyxir
# # Copy the PLT files into the dialyxir directory
# cp -f _build/dev/dialyxir* dialyxir

# RUN mix dialyzer --plt

CMD ["iex"]

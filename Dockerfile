ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.1.1
ARG DEBIAN_VERSION=bullseye-20230612-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# pass via build args: --build-arg MIX_ENV=dev
ARG MIX_ENV=prod

ENV MIX_ENV=${MIX_ENV}

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /opt/app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get
RUN mix deps.compile

COPY . .

RUN mix compile

FROM builder as dev

# Dev dependencies
RUN apt-get update && apt-get install -y inotify-tools

ENV MIX_ENV=dev

CMD [ "mix", "phx.server" ]
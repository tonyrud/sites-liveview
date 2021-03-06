# Site Controller Demo

Phoenix LiveView playground

Using

- PubSub for real-time updates
- PostGIS for point to point location searching
- Dockerized local development
- GH Actions for CI on PRs
- Dockerized releases and deployed via ECS

## Start application

```bash
docker-compose up --build
```

## Connect to Containers

Note: must be in this directory to run `docker-compose` commands

postgres instance

```bash
docker-compose exec db bash -c "psql --host=localhost --user=postgres"
```

iex

```bash
docker-compose exec phoenix iex -S mix

# Get all sites query
Demo.Sites.list_sites
```

## Tests

Note: testing config runs against Docker db port by default

```bash
mix test
```

## Links

[Sites](http://localhost:4000/sites)

[Dashboard](http://localhost:4000/dashboard/home)

## TODOs

- [ ] Module and function docs
- [ ] Unit tests
- [ ] Handle lists of flash messages when editing/creating
- [ ] Modal as a LiveComponent
- [ ] Uncheck boxes after editing
- [ x ] Add ci: credo, dialyxer, formatting

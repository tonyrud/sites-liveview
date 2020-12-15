# Site Controller Demo

Phoenix LiveView playground

Using

- PubSub for real-time updates
- PostGIS for point to point location searching
- Dockerized local development
- GH Actions for CI on PRs
- Dockerized released and deployed via ECS

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

```bash
MIX_ENV=test mix test
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
- [ ] Add ci: credo, dialyxer, ~formatting~

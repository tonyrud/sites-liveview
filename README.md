# Site Controller Demo

Phoenix LiveView project

## Start application

```bash
docker-compose up --build
```

## Connect to Containers

postgres instance

```bash
docker exec -it demo_db_1 psql --host=localhost --user=postgres
```

iex

```bash
docker exec -it demo_phoenix_1 iex -S mix run
```

## Links

[Sites](http://localhost:4000/sites)

[Dashboard](http://localhost:4000/dashboard/home)

## TODOs

- [ ] Module and function docs
- [ ] Unit tests
- [ ] Styling
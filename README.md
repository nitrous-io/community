## Nitrous Community

Community website for Nitrous.IO.

### Set up DB

- Set your `DB_URL` environment variable:

```
export DB_URL="postgres://[dbuser]:[dbpassword]@[host]/[dbname]?sslmode=disable"
```

- Install `go get github.com/mattes/migrate`.
- Run migrations: `make migrate`.

### Port

Server has been configured to listen on port `8080`. If you want to change it, set the `PORT` environment variable.

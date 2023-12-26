# To download a copy of the database

In one terminal, proxy a port:

`fly proxy 15432:5432 -a stardate-db`

To discover the database info:

`fly ssh console`
`echo $DATABASE_URL` -> `postgres://stardate:{{PASSWORD}}@{{HOST}}:5432/stardate?sslmode=disable`

Use that info to pg_dump from local machine:

`pg_dump postgres://stardate:{{PASSWORD}}@localhost:15432/stardate > ~/Downloads/stardate.sql`

Then import into database:

`psql stardate_development < ~/Downloads/stardate.sql`

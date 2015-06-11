# Firebrick

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.


## Development install

Clone the project

```
git clone https://github.com/HashNuke/firebrick.git firebrick
cd firebrick
```

#### Install Erlang, Elixir & Node.js

Install Erlang, Elixir & Node.js versions specified in the `.tool-versions` file.

**OR** If using [asdf](http://github.com/HashNuke/asdf), just run `asdf install` within project dir.

#### Postgres

* Change the postgres credentials in `config/test.exs`.
  OR
  Create postgres user called `postgres` with password `postgres`
  ```
  TODO
  ```

* Create postgres database `firebrick_dev`

  ```sh
  createdb firebrick_dev
  ```

#### Install dependencies & migrate database

```
mix deps.get
mix setup
cd frontend
npm install
cd -
```

#### Run the app

```
mix phoenix.server
```

## References

##### Mac port-forwarding

* <http://www.chrisvanpatten.com/port-forwarding-mavericks>
* <https://gist.github.com/kujohn/7209628>

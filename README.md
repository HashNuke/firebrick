# Firebrick

Email application


## Development install

Clone the project

```sh
git clone https://github.com/HashNuke/firebrick.git firebrick
cd firebrick
```

#### Install Erlang, Elixir & Node.js

Install Erlang, Elixir & Node.js versions specified in the `.tool-versions` file.

**OR** If using [asdf](http://github.com/HashNuke/asdf), just run `asdf install` within project dir.

#### Postgres

* Change the postgres credentials in `config/test.exs`.
  OR
  Create postgresql user called `postgres` with password `postgres`
  ```sh
  createuser -dsP postgres
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
# OR
iex -S mix phoenix.server
```

If starting using `iex`, use `Firebrick.send_test_mail` to send a test mail.

> Running just `iex -S mix` won't start the mail server. The mail server is not started if the Phoenix server isn't started.

## References

##### Mac port-forwarding

* <http://www.chrisvanpatten.com/port-forwarding-mavericks>
* <https://gist.github.com/kujohn/7209628>

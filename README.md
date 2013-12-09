# Firebrick

[![Build Status](https://travis-ci.org/HashNuke/firebrick.png?branch=master)](https://travis-ci.org/HashNuke/firebrick)

## Install and configuring dependencies (temporary, expect changes in the future)

Firebrick requires Riak 2.0 and Elixir v0.11.2. At the time of writing, the latest version of is Riak 2.0pre7 (from the tag in the Riak git repo).

### Configure incoming mail port

Run the following command to redirect port 25 traffic to port 2525.

    sudo iptables -t nat -A PREROUTING -p tcp -m tcp --dport 25 -j REDIRECT --to-ports 2525

The above command is for Ubuntu, figure out something else for your operating system.

### Configure Riak

* Turn on Riak Search 2.0 in Riak's `riak.conf`

* Start Riak with `riak start`

* Create an index

        curl -XPUT -i 'http://localhost:8098/search/index/firebrick_index'

* Create a bucket type which uses the index and also activate it.

        riak-admin bucket-type create firebrick_type '{"props":{"search_index":"firebrick_index"}}'
        riak-admin bucket-type activate firebrick_type


## Setup

* Clone this repository
* Run `mix deps.get` to install dependencies
* Start the app with `iex --erl "-config firebrick.config" -S mix server`. You will also get a console.

* Run the following in the console.

  Firebrick.Installer.install("yourdomain.com")

  It will create add a domain to receive mail at and also an admin user (username: admin, password: password)

* To send a test mail, run `Firebrick.Smtp.send_test_mail`

* You can login at http://localhost:4000 and view it


## Development

#### Ruby

You'll have to install Ruby if you are touching any of the assets (coffeescripts or stylesheets).

Run the following commands to install the `bundler` rubygem and then the other dependencies.

* `gem install bundler` - installs the bundler rubygem
* `bundle install` - Other ruby dependencies


#### Asset compilation

After installing the Ruby dependencies, you can compile assets using any of the following commands:

* `bundle exec rake assets:compile` - Compile assets

* `bundle exec rake assets:watch` - Watch assets for changes during development and compile them.


Check `docs/asset-compilation-using-watchman.md` for notes on auto-compilation on asset changes.


## Development/personal notes

* Reference for email threading - http://www.jwz.org/doc/threading.html
* Forward port-25 to 2525

      sudo iptables -t nat -A PREROUTING -p tcp -m tcp --dport 25 -j REDIRECT --to-ports 2525

* Tag all incoming mails with "inbox"
* To delete the index and start over again:

      # clear the directory for the solr index
      curl -XDELETE -i 'http://localhost:8098/search/index/firebrick_index'
      curl -XPUT -i 'http://localhost:8098/search/index/firebrick_index'

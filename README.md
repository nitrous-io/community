# Community

Community Site for Nitrous.IO.

# Development

## Requirements
 - Ruby ( >= 2.0.0 )
 - PostgreSQL ( >= 9.2 )

## Setup

  1. Install gems with Gemfile

  ```sh
  $ bundle
  ```

  2. Prepare PostgreSQL database

  ```sh
  $ cp config/database.yml.example config/database.yml # Create database.yml from config/database.yml.example
  $ rake db:create db:migrate # Create and migrate database
  ```

  3. Create .env file from .env-sample for environment variables

  ```sh
  $ cp .env-sample .env # It will be loaded by `dotenv-rails` gem
  ```

## Test

### Setup

  1. Reset test database with current schema.rb

  ```
    $ rake db:test:prepare
  ```

  2. Install phantomjs to test javascript with command line

  ```sh
    $ sudo apt-get install phantomjs
  ```

  3. Run rspec tests

  ```sh
    $ spring rspec spec
  ```

  4. Run test

  ```sh
    $ bundle exec rake konacha:run
  ```

## Running server
```sh
  $ ./start-app
```

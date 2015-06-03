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
  $ rake db:create db:migrate db:test:prepare # Create and migrate database
  ```

  3. Create .env file from .env-sample for environment variables

  ```sh
  $ cp .env-sample .env # It will be loaded by `dotenv-rails` gem
  ```

## Test
```sh
  $ spring rspec spec
```

## Running server
```sh
  $ ./start-app
```
# README

Ruby version: 2.7.4p191
Rails version: 6.1.4.1

## Installation

You will need to get a free Nomics API key and add it to the environment variable NOMICS_API_KEY
https://p.nomics.com/cryptocurrency-bitcoin-api

Then run `$ bundle install` to install and `$ rails server` to get the application running at http://localhost:3000.

## Tests

First run `$ rake db:test:prepare` to load the test database.

To run the rspec tests, simply run `$ rspec` from the command line.
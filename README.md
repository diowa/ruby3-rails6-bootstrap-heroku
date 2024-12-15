# Rails 6 Starter App
[![Build Status](https://github.com/diowa/ruby3-rails6-bootstrap-heroku/actions/workflows/ci.yml/badge.svg)](https://github.com/diowa/ruby3-rails6-bootstrap-heroku/actions)
[![Code Climate](https://codeclimate.com/github/diowa/ruby3-rails6-bootstrap-heroku/badges/gpa.svg)](https://codeclimate.com/github/diowa/ruby3-rails6-bootstrap-heroku)
[![Coverage Status](https://coveralls.io/repos/github/diowa/ruby3-rails6-bootstrap-heroku/badge.svg?branch=main)](https://coveralls.io/github/diowa/ruby3-rails6-bootstrap-heroku?branch=main)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This is an opinionated starter web application based on the following technology stack:
* [Ruby 3.1.6][:ruby-url]
* [Rails 6.1.7.10][:ruby-on-rails-url]
* [Webpack 5][:webpack-url] (via [Shakapacker][:shakapacker-url])
* [Yarn][:yarn-url]
* [Puma][:puma-url]
* [PostgreSQL][:postgresql-url]
* [Redis][:redis-url]
* [RSpec][:rspec-url]
* [Bootstrap 5.3.3][:bootstrap-url]
* [Autoprefixer][:autoprefixer-url]
* [Font Awesome 6.7.1 SVG][:fontawesome-url]
* [Slim][:slim-url]
* [RuboCop][:rubocop-url]
* [RuboCop RSpec][:rubocop-rspec-url]
* [Slim-Lint][:slim-lint-url]
* [stylelint][:stylelint-url]

[:autoprefixer-url]: https://github.com/postcss/autoprefixer
[:bootstrap-url]: https://getbootstrap.com/
[:fontawesome-url]: https://fontawesome.com/
[:postgresql-url]: https://www.postgresql.org/
[:puma-url]: https://puma.io/
[:redis-url]: https://redis.io/
[:rspec-url]: https://rspec.info/
[:rubocop-rspec-url]: https://github.com/backus/rubocop-rspec
[:rubocop-url]: https://github.com/bbatsov/rubocop
[:ruby-on-rails-url]: https://rubyonrails.org/
[:ruby-url]: https://www.ruby-lang.org/en/
[:shakapacker-url]: https://github.com/shakacode/shakapacker
[:slim-lint-url]: https://github.com/sds/slim-lint
[:slim-url]: http://slim-lang.com/
[:stylelint-url]: https://stylelint.io/
[:webpack-url]: https://webpack.js.org/
[:yarn-url]: https://yarnpkg.com/lang/en/

Starter App is deployable on [Heroku](https://www.heroku.com/). Demo: https://ruby3-rails6-bootstrap-heroku.herokuapp.com/

```Gemfile``` also contains a set of useful gems for performance, security, api building...

### Thread safety

We assume that this application is thread safe. If your application is not thread safe or you don't know, please set the minimum and maximum number of threads usable by puma on Heroku to 1:

```sh
$ heroku config:set RAILS_MAX_THREADS=1
```

### Master Key

Rails 5.2 introduced [encrypted credentials](https://edgeguides.rubyonrails.org/5_2_release_notes.html#credentials).

The master key used by this repository is:

```
02a9ea770b4985659e8ce92699f218dc
```

**DO NOT SHARE YOUR MASTER KEY. CHANGE THIS MASTER KEY IF YOU ARE GOING TO USE THIS REPO FOR YOUR OWN PROJECT.**

### Heroku Platform API

This application supports fast setup and deploy via [app.json](https://devcenter.heroku.com/articles/app-json-schema):

```sh
$ curl -n -X POST https://api.heroku.com/app-setups \
-H "Content-Type:application/json" \
-H "Accept:application/vnd.heroku+json; version=3" \
-d '{"source_blob": { "url":"https://github.com/diowa/ruby3-rails6-bootstrap-heroku/tarball/main/"} }'
```

More information: [Setting Up Apps using the Platform API](https://devcenter.heroku.com/articles/setting-up-apps-using-the-heroku-platform-api)

### Recommended add-ons

Heroku's [Production Check](https://blog.heroku.com/introducing_production_check) recommends the use of the following add-ons, here in the free version:

```sh
$ heroku addons:create newrelic:wayne # App monitoring
$ heroku config:set NEW_RELIC_APP_NAME="Rails 6 Starter App" # Set newrelic app name
$ heroku addons:create papertrail:choklad # Log monitoring
```

### Tuning Ruby's RGenGC

Generational GC (called RGenGC) was introduced from Ruby 2.1.0. RGenGC reduces marking time dramatically (about x10 faster). However, RGenGC introduce huge memory consumption. This problem has impact especially for small memory machines.

Ruby 2.1.1 introduced new environment variable RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR to control full GC timing. By setting this variable to a value lower than the default of 2 (we are using the suggested value of 1.3) you can indirectly force the garbage collector to perform more major GCs, which reduces heap growth.

```sh
$ heroku config:set RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.3
```

More information: [Change the full GC timing](https://bugs.ruby-lang.org/issues/9607)

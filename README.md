Express Translate
=====
I18n Translation Interface for end user in Rails app

  ```bash
   __                               _____                     _       _       
  /__\_  ___ __  _ __ ___ ___ ___  /__   \_ __ __ _ _ __  ___| | __ _| |_ ___ 
 /_\ \ \/ / '_ \| '__/ _ \ __/ __|   / /\/ '__/ _` | '_ \/ __| |/ _` | __/ _ \
//__  >  <| |_) | | |  __\__ \__ \  / /  | | | (_| | | | \__ \ | (_| | |_  __/
\__/ /_/\_\ .__/|_|  \___|___/___/  \/   |_|  \__,_|_| |_|___/_|\__,_|\__\___|
          |_|                                                                 
  ``` 

[![Gem Version](https://badge.fury.io/rb/express_translate.svg)](http://badge.fury.io/rb/express_translate)
[![Code Climate](https://codeclimate.com/github/RubifyTechnology/express_translate.png)](https://codeclimate.com/github/RubifyTechnology/express_translate)
[![Build Status](https://travis-ci.org/RubifyTechnology/express_translate.svg?branch=master)](https://travis-ci.org/RubifyTechnology/express_translate)
[![Dependency Status](https://gemnasium.com/RubifyTechnology/express_translate.svg)](https://gemnasium.com/RubifyTechnology/express_translate)
[![Coverage Status](https://coveralls.io/repos/RubifyTechnology/express_translate/badge.png)](https://coveralls.io/r/RubifyTechnology/express_translate)
[![Inline docs](http://inch-ci.org/github/RubifyTechnology/express_translate.png?branch=master)](http://inch-ci.org/github/RubifyTechnology/express_translate)

=====

## Installation
### 1. Gemfile
```bash
gem 'express_translate', '~> 1.0.11'
```
 
### 2. Setup
Run on terminal.

```bundle install```

### 3. Install
Open terminal and run:

```rails g express_translate:install```

## Using
### Run
Start Redis Server
``redis-server``

###Basic usage
You can see login page at: ``/express_translate/login``

Login with account:
```bash
username: "username"
password: "password"
```

###Advanced usage
#### Modify accounts

Account list config in ``/config/express_translate.yml``.
You can add account:
```bash
account: 
  - 
    username: "your_username"
    password: "your_password"
```

You need reset account for modified

**``http://you_domain/express_translate/reset/account``**

#### Seed data

``rails g express_translate:seed``

#### Reset data
``rails g express_translate:reset``

#### i18next
Add script to header page
``<script src="http://you_domain/express_translate/i18n/package_id"></script>``
Note: 
* you_domain: e.g ``localhost:3000``
* package_id: is a package id.

## Support

#### Import files
* CSV file
* YML file

#### Export files
* CSV file

#### Application
* Backend for Ruby on Rails
* Frontend (Single Page Application) with I18next (can you see more info: http://i18next.com)

## Supported ruby versions
- This library aims to support and is tested against the following Ruby implementations:
 	* Ruby 1.9.3
  * Ruby 2.0.0
  * Ruby 2.1.2
  
## Supported rails versions
- This library aims to support the following Rails implementations:
 	* More than Rails 3.0
  
## Contributing to formnestic
 
- Contribution, Suggestion and Issues are very much appreciated :). Please also fork and send your pull request!
- Make sure to add tests for it when sending for pull requests. This is important so I don't break it in a future version unintentionally.

## Copyright

Copyright (c) 2014 Karl, released under the MIT license
Express Translate
=====

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

##Installation
### 1. Gemfile
```bash
gem 'express_translate', '~> 1.0.8'
```
 
### 2. Setup
Run on terminal.
```bash
gem install express_translate
```

```bash
bundle install
```

### 3. Install
Open terminal and run:

```bash
rails g express_translate:install
 ``` 
  
##Using
### Run
Start Redis Server
```bash
redis-server
```

### Modify accounts

Account list config in "/config/express_translate.yml".
You can add account:
```bash
account: 
  - 
    username: "abc_name"
    password: "abc_pass"
```

You need reset account for modified
```bash
rails g express_translate:reset_account
```
Or goto url
```bash
  http://you_domain/express_translate/reset/account

  * e.g: http://localhost:3000/express_translate/reset/account
```

### Seed
```bash
rails g express_translate:seed
```

### Reset data
```bash
rails g express_translate:reset
```

### Login page
You can see login page at:
  http://you_domain/express_translate/login

  * e.g: http://localhost:3000/express_translate/login
  
### Packages management
You can see at: 
  http://you_domain/express_translate

  * e.g: http://localhost:3000/express_translate
  
Note: You can see before login. Account for login in config file ("/config/express_translate.yml").

### i18next
Add script to header page
```bash
<script src="http://you_domain/express_translate/i18n/app_code"></script>
```
Note: 
* you_domain: e.g "localhost:3000"
* app_code: is a application code.

##Support

### Files
#### Import
  * CSV file
  * YML file

#### Export
  * CSV file

### Application
* Backend for Ruby on Rails
* Frontend (Single Page Application) with I18next (can you see more info: http://i18next.com)

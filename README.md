Express Translate
=====

[![Code Climate](https://codeclimate.com/github/RubifyTechnology/express_translate.png)](https://codeclimate.com/github/RubifyTechnology/express_translate)
[![Build Status](https://travis-ci.org/RubifyTechnology/express_translate.svg?branch=master)](https://travis-ci.org/RubifyTechnology/express_translate)

=====

##Installation
###1. Gemfile
  ```bash
  gem 'rubify_dashboard', :git => 'git@github.com:RubifyTechnology/express_translate.git'
  ```
  
###2. Config
  Create new file: "/config/rlang.yml" with content.
  
  ```bash
  connect:
    host: "0.0.0.0"
    port: 6379
    db: rubify_languages
    # password: "password"
    # path: "/tmp/redis.sock"
    
  language:
    id: en
    text: English
  package:
    id: be
    text: Backend

  account: 
    - 
      username: "karl_nguyen"
      password: "********"
    - 
      username: "karl_nguyen_1"
      password: "********"
   ``` 
   
###3. Setup
  Run on terminal.
  '''bash
    bundle install
  '''
  
  and start Redis Server
  '''bash
    redis-server
  '''
  
##Using
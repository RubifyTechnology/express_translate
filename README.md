   ```bash
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
   .,,''''.                                                                                           
   .o.      .    .. ......   ....   ....    ....   ....                                               
   .d;''''. 'c'.::. co;''cc. co:. 'c,..::..l;.',. ;l'.,'                                              
   .o'....   .od:   ::   .o' ::  .dl,,,;c' ,:::,. .::;;.                                              
   .o'....  .c;'c,  cl'..;o. :;   :l.....  ....cc ....,o.                                             
   .;;;;;,..'.   '..cc,,;,.  ..    .,;;,.  .,,,'. .,,;,.                                              
                    ;,                       .                                                        
                                       ',;ol,,'                             .l.         .;.           
                                          :;   ,::,..,::::. .::;::;  .;;:;. .o. .;:;:;..:xc.  ,;,;;.  
                                          :;   cc.   ,,''l, .o,  .o. cc'..  .o. .,,.'o, .o.  ll...,o. 
                                          :;   :;   cc..'l, .o.   l.  ..,:c .o. c:..,d, .o. .ol,''''. 
                                          :;   :;   'c,';l' .l.   c. ,;,':; .l. ,:'';o,  cl, .::,,:,  
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
   
   ```                                                                                                                                   
Express Translate
=====

[![Gem Version](https://img.shields.io/gem/v/express_translate.svg)](https://rubygems.org/gems/express_translate)
[![Code Climate](https://codeclimate.com/github/RubifyTechnology/express_translate.png)](https://codeclimate.com/github/RubifyTechnology/express_translate)
[![Build Status](https://travis-ci.org/RubifyTechnology/express_translate.svg?branch=master)](https://travis-ci.org/RubifyTechnology/express_translate)
[![Dependency Status](https://gemnasium.com/RubifyTechnology/express_translate.svg)](https://gemnasium.com/RubifyTechnology/express_translate)
[![Coverage Status](https://coveralls.io/repos/RubifyTechnology/express_translate/badge.png)](https://coveralls.io/r/RubifyTechnology/express_translate)

=====

##Installation
###1. Gemfile
  ```bash
  gem 'rubify_dashboard', :git => 'git@github.com:RubifyTechnology/express_translate.git'
  ```
  
###2. Install
  Open terminal and run:
  
  ```bash
  rails g express_translate:install
   ``` 
   
###3. Setup
  Run on terminal.
  ```bash
  bundle install
  ```
  
  and start Redis Server
  ```bash
  redis-server
  ```
  
##Using
### Login page
  You can see login page at:
    http://you_domain/express_translate/login
  
    * e.g: http://localhost:3000/express_translate/login
  
### Packages management
  You can see at: 
    http://you_domain/express_translate
  
    * e.g: http://localhost:3000/express_translate
    
  Note: You can see before login. Account for login in config file ("/config/express_translate.yml").
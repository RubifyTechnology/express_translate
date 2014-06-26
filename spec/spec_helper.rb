require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'spork'
# encoding: utf-8
require 'bundler'
Bundler.setup
require 'active_support'
require 'action_pack'
require 'action_view'
require 'action_controller'
require 'action_dispatch'
require 'rspec/autorun'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories in alphabetic order.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f}

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # include ActionView::Helpers::FormHelper
  # include ActionView::Helpers::FormTagHelper
  # include ActionView::Helpers::FormOptionsHelper
  # include ActionView::Helpers::UrlHelper
  # include ActionView::Helpers::TagHelper
  
  module RubifyDashboardSpecHelper
    
    def mock_everything
      @fred = Author.create({name: "Fred"})  
      @post = Post.create({title: "New Title", content: "Some Content", author_id: @fred.id})    
    end

    def self.included(base)      
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

::ActiveSupport::Deprecation.silenced = false

RSpec.configure do |config|
  config.before(:all) do
    DeferredGarbageCollection.start unless ENV["DEFER_GC"] == "false"
  end
  config.after(:all) do
    DeferredGarbageCollection.reconsider unless ENV["DEFER_GC"] == "false"
  end
end

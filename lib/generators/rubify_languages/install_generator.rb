require 'securerandom'
require 'rails/generators'
require 'rails/generators/migration'

module RubifyDashboard
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      def test_seed
        [1..10].each do |i|
          puts i
        end
      end
      
    end
  end
end

# require 'securerandom'
# require 'rails/generators'
# require 'rails/generators/migration'
#
# module RubifyLanguages
#   module Generators
#     class InstallGenerator < Rails::Generators::Base
#       include Rails::Generators::Migration
#
#       def copy_initializer
#         [1..10].each do |i|
#           puts i
#         end
#       end
#
#     end
#   end
# end




module RubifyLanguages
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    def add_my_initializer
      template "config/rlang.yml", "config/rlang1.yml"
    end
  end
end


require 'securerandom'
require 'rails/generators'
require 'rails/generators/migration'

module Rlang
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    def create_file_config
      template "config/rlang.yml", "config/rlang.yml"
    end
  end
end


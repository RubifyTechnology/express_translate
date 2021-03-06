require 'securerandom'
require 'rails/generators'
require 'rails/generators/migration'

module ExpressTranslate
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    include ExpressTranslate
    
    # Copy config file for my gem
    def create_file_config
      template "config/express_translate.yml", "config/express_translate.yml"
    end
    
    # Seed data for redis database
    def seeds_data
      ExpressTranslate.seeds
      Account.reset
    end
  end
end


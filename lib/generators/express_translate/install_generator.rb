require 'securerandom'
require 'rails/generators'
require 'rails/generators/migration'

module ExpressTranslate
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    include ExpressTranslate
    
    def create_file_config
      template "config/express_translate.yml", "config/express_translate.yml"
    end
    
    def seeds_data
      ExpressTranslate.seeds
    end
  end
end


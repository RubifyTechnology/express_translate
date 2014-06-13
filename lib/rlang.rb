require 'modules/rlang_model'
require 'modules/database_management'
require 'modules/package_management'
require 'modules/languages_management'

# Seeds
require 'seeds/packages_seed'
require 'seeds/languages_seed'

module RubifyLanguages  
  def self.config
    YAML.load_file(Rails.root.to_s + "/config/rlang.yml")
  end
  
  def self.seeds
    if Package.all.count == 0
      Package.seed
      Language.seed
    end
  end
  
  def self.reset
    Database.clear
  end
  
  def self.clear
    Package.destroy
    Language.destroy
  end
  
  # def self.setup
#     yield self
#   end
  
  def initialize
  end
    
  class Engine < Rails::Engine
  end
end
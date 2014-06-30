require 'express_translate/express_translate_model'
require 'express_translate/database_management'
require 'express_translate/account_management'
require 'express_translate/package_management'
require 'express_translate/languages_management'
require 'express_translate/language_detail_management'

# Seeds
require 'seeds/packages_seed'
require 'seeds/languages_seed'
require 'seeds/accounts_seed'

# Lib
require 'redis'

module ExpressTranslate
  
  class << self; attr_accessor :package, :language, :url end
  
  @package = ""
  @language = ""
  @url = ""
  
  def language(lang)
    I18n.locale = "#{YAML.load_file(Rails.root.to_s + '/config/express_translate.yml')['package']['id']}#{lang}"
  end
  
  def self.root
    File.expand_path '../..', __FILE__
  end
  
  def self.config
    YAML.load_file(Rails.root.to_s + "/config/express_translate.yml")
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
    LanguageDetail.destroy
  end
  
  # def initialize
#
#   end
      
  def self.setup
    yield self        
  end
  
  class Engine < Rails::Engine
    TRANSLATION_STORE = Redis.new
    I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)
    I18n.locale = "been"
    
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end
  end
end
require 'rubify_languages/rlang_model'
require 'rubify_languages/database_management'
require 'rubify_languages/account_management'
require 'rubify_languages/package_management'
require 'rubify_languages/languages_management'
require 'rubify_languages/language_detail_management'

# Seeds
require 'seeds/packages_seed'
require 'seeds/languages_seed'
require 'seeds/accounts_seed'

# Lib
require 'redis'

module RubifyLanguages
  
  class << self; attr_accessor :package, :language, :url end
  
  @package = ""
  @language = ""
  @url = ""
  
  def language(lang)
    I18n.locale = "#{YAML.load_file(Rails.root.to_s + '/config/rlang.yml')['package']['id']}#{lang}"
  end
  
  def self.root
    File.expand_path '../..', __FILE__
  end
  
  def self.config
    YAML.load_file(Rails.root.to_s + "/config/rlang.yml")
  end
  
  def self.seeds
    if Package.all.count == 0
      Package.seed
      Language.seed
      Account.seed
    end
  end
  
  def self.reset
    Database.clear
  end
  
  def self.clear
    Package.destroy
    Language.destroy
  end
  
  def initialize
    
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
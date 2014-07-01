# Class in my gem
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
require 'rails'

# Main module for my gem
module ExpressTranslate
  
  class << self; attr_accessor :package, :language, :url end
  
  @package = ""
  @language = ""
  @url = ""
  
  # Change language locals for I18N
  # @lang: is a code of language want to change for backend
  def language(lang)
    I18n.locale = "#{YAML.load_file(Rails.root.to_s + '/config/express_translate.yml')['package']['id']}#{lang}"
  end
  
  def self.root
    File.expand_path '../..', __FILE__
  end
  
  def self.config
    file_name = Rails.root.to_s + "/config/express_translate.yml"
    file_name = File.exist?(file_name) ? file_name : self.root + "/lib/generators/express_translate/templates/config/express_translate.yml"
    return YAML.load_file(file_name)
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
  # end
      
  # Setup My gem
  def self.setup
    yield self        
  end
  
  class Engine < Rails::Engine
    TRANSLATION_STORE = Redis.new
    I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)
    I18n.enforce_available_locales = false
    I18n.locale = "been"
  end
end
class ExpressTranslate::OptionsController < ExpressTranslate::BaseController

  # Check login status for controller
  before_filter :check_login
  
  # Require and include Libraries
  require 'redis'
  require 'json'
  require 'csv'
  include ExpressTranslate
  
  # Show all packages for client (html code) index page
  # Get all packages
  def index
    @packages = Package.all
    render :action => :index, layout: 'express_translate/translate'
  end
  
  # Show all languages for client (html code) index page
  # Get all languages of package ID
  # Get origin languages
  # Get max count of percent translate
  def languages
    @selects = YAML.load_file("#{ExpressTranslate.root}/config/languages.yml")
    @origin = Language.get_origin(params[:packages])
    @origin_keys = @origin.present? ? LanguageDetail.info(@origin).all.collect{|x| x['code']} : []
    @languages = Package.find(params[:packages])['language']
    @max = @origin.nil? ? 1 : LanguageDetail.info(@origin).all.count
    @LanguageDetail = LanguageDetail
    @Package = Package
    render :action => :languages, layout: 'express_translate/translate'
  end
  
  
  # Show all codes for client (html code) index page
  # Get all codes of package ID and language ID
  # Get origin language
  # Get language for show
  def language_detail
    @languages = Package.find(params[:package])['language']
    @origin_lang = Language.get_origin(params[:package])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:id], 'packages'=> params[:package]}
    render :action => :language_detail, layout: 'express_translate/translate'
  end
  
  private   
  
  # Check login status for controller
  def check_login
    if !check_authentication
      redirect_to controller: "account", action: "login"
    end
  end
end
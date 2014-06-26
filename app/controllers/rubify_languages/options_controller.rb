class RubifyLanguages::OptionsController < RubifyLanguages::BaseController

  before_filter :check_login
  
  require 'redis'
  require 'json'
  require 'csv'
  
  include RubifyLanguages
  
  def index
    # RubifyLanguages.reset
#     RubifyLanguages.seeds
    @packages = Package.all
    render :action => :index, layout: 'rubify_languages/translate'
  end
    
  def languages
    @selects = YAML.load_file("#{RubifyLanguages.root}/config/languages.yml")
    origin = Language.get_origin(params[:packages])
    @languages = Package.find(params[:packages])['language']
    @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
    @LanguageDetail = LanguageDetail
    @Package = Package
    render :action => :languages, layout: 'rubify_languages/translate'
  end
  
  def language_detail
    @languages = Package.find(params[:package])['language']
    @origin_lang = Language.get_origin(params[:package])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:id], 'packages'=> params[:package]}
    render :action => :language_detail, layout: 'rubify_languages/translate'
  end
  
  private   
    
  def check_login
    if !check_authentication
      redirect_to controller: "account", action: "login"
    end
  end
end
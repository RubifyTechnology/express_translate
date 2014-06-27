class ExpressTranslate::OptionsController < ExpressTranslate::BaseController

  before_filter :check_login
  
  require 'redis'
  require 'json'
  require 'csv'
  
  include ExpressTranslate
  
  def index
    # ExpressTranslate.reset
#     ExpressTranslate.seeds
    @packages = Package.all
    render :action => :index, layout: 'express_translate/translate'
  end
    
  def languages
    @selects = YAML.load_file("#{ExpressTranslate.root}/config/languages.yml")
    origin = Language.get_origin(params[:packages])
    @languages = Package.find(params[:packages])['language']
    @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
    @LanguageDetail = LanguageDetail
    @Package = Package
    render :action => :languages, layout: 'express_translate/translate'
  end
  
  def language_detail
    @languages = Package.find(params[:package])['language']
    @origin_lang = Language.get_origin(params[:package])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:id], 'packages'=> params[:package]}
    render :action => :language_detail, layout: 'express_translate/translate'
  end
  
  private   
    
  def check_login
    if !check_authentication
      redirect_to controller: "account", action: "login"
    end
  end
end
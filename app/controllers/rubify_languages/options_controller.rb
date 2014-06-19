class RubifyLanguages::OptionsController < ActionController::Base

  before_filter :check_authentication
  # http_basic_authenticate_with name: "dhh", password: "secret", except: :index

  require 'redis'
  require 'json'
  
  include RubifyLanguages
  
  def index
    # RubifyLanguages.reset
#     RubifyLanguages.seeds
    @packages = Package.all
    render :action => :index, layout: 'rubify_languages/translate'
  end
    
  def languages
    @selects = YAML.load_file(Rails.root.to_s + "/config/languages.yml")
    puts @selects
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
  
  # AJAX
  def code_add
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    add = @lang_detail.add(params)
    if add['success']
      load_content_code(params)
    else
      render :json => add
    end
  end
  
  def code_update
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    if @lang_detail.find(params[:code]).present?
      @lang_detail.update(params)
    else
      @lang_detail.add(params)
    end
    load_content_code(params)
  end
  
  def code_delete
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.delete(params[:code])
    load_content_code(params)
  end
  
  
  def language_add
    add = Language.add(params)
    if add['success']
      load_content_language(params)
    else
      render :json => add
    end
  end
  
  def language_update
    update = Language.update_by_id_packages(params[:id], params[:packages], params)
    if update['success']
      load_content_language(params)
    else
      render :json => update
    end
  end
  
  def language_delete
    delete = Language.delete_by_id_packages(params[:id], params[:packages])
    if delete['success']
      load_content_language(params)
    else
      render :json => delete
    end
  end
  
  def language_set_origin
    update = Language.set_origin(params[:id], params[:packages])
    if update['success']
      load_content_language(params)
    else
      render :json => update
    end
  end
  
  
  def package_add
    add = Package.add(params)
    if add['success']
      load_content_package(params)
    else
      render :json => add
    end
  end
  
  def package_update
    update = Package.update(params)
    if update['success']
      load_content_package(params)
    else
      render :json => update
    end
  end
  
  def package_delete
    delete = Package.delete(params[:id])
    if delete['success']
      load_content_package(params)
    else
      render :json => delete
    end
  end
  
  private
  
  def load_content_code(params)
    @origin_lang = Language.get_origin(params[:pack])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:lang], 'packages'=> params[:pack]}
    render :action => :code_update
  end
  
  def load_content_language(params)
    origin = Language.get_origin(params[:packages])
    @languages = Package.find(params[:packages])['language']
    @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
    @LanguageDetail = LanguageDetail
    render :action => :language_update
  end
  
  def load_content_package(params)
    @packages = Package.all
    render :action => :package_update
  end
  
  def load_all_yaml(lang="en")
    I18n.backend.send(:translations)[lang.to_sym]
  end      
    
  def check_authentication
    
    # if (request.headers['app-key'].to_s != APP_CONFIG[:api_key])
#       return render text: 'unauthorized access', status: :unauthorized
#     end
    # if self.respond_to?(:rlang_accessible?) == false
    #   # okay, can let anyone go in
    # else
    #   if self.rlang_accessible? == true
    #     # okay, can let this person go in
    #   else
    #     redirect_to '/401'
    #   end
  end  
  
  
end
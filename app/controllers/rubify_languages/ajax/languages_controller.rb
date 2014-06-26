class RubifyLanguages::Ajax::LanguagesController < ActionController::Base
  require 'redis'
  require 'json'
  require 'csv'
  include RubifyLanguages
  
  def language_add
    load_content_language(params, Language.add(params))
  end
  
  def language_update
    load_content_language(params, Language.update_by_id_packages(params[:old_id], params[:packages], params))
  end
  
  def language_delete
    load_content_language(params, Language.delete_by_id_packages(params[:id], params[:packages]))
  end
  
  def language_set_origin
    load_content_language(params, Language.set_origin(params[:id], params[:packages]))
  end
  
  private
  
  def load_content_language(params, check)
    if check['success']
      origin = Language.get_origin(params[:packages])
      @languages = Package.find(params[:packages])['language']
      @max = origin.nil? ? 1 : LanguageDetail.info(origin).all.count
      @LanguageDetail = LanguageDetail
      render :action => :language_update
      return
    end
    render :json => check
  end
end
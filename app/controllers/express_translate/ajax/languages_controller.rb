class ExpressTranslate::Ajax::LanguagesController < ActionController::Base
  
  # Include and require Libraries  
  require 'redis'
  require 'json'
  require 'csv'
  include ExpressTranslate
  
  # Add language
  # Load html content when add Language
  def language_add
    load_content_language(params, Language.add(params))
  end
  
  # Update language
  # Load html content when update Language
  def language_update
    load_content_language(params, Language.update_by_id_packages(params[:old_id], params[:packages], params))
  end
  
  # Delete language
  # Load html content when delete Language
  def language_delete
    load_content_language(params, Language.delete_by_id_packages(params[:id], params[:packages]))
  end
  
  # Set origin language
  # Load html content when set origin Language for package
  def language_set_origin
    load_content_language(params, Language.set_origin(params[:id], params[:packages]))
  end
  
  private
  
  # Load language html content
  # The firstly: check status for action add, update, delete and set origin language
    # get origin language for know max count => percent complete
    # get max number language origin
    # render to html content
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
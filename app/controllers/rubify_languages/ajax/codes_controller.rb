class RubifyLanguages::Ajax::CodesController < ActionController::Base
  require 'redis'
  require 'json'
  require 'csv'
  include RubifyLanguages
  
  def code_add
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    add = @lang_detail.add(params)
    add['success'] ? load_content_code(params) : (render :json => add)
  end
  
  def code_update
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})    
    @lang_detail.find(params[:code]).present? ? @lang_detail.update(params) : @lang_detail.add(params)
    load_content_code(params)
  end
  
  def code_delete
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.delete(params[:code])
    load_content_code(params)
  end
  
  private
  
  def load_content_code(params)
    @origin_lang = Language.get_origin(params[:pack])
    @LanguageDetail = LanguageDetail
    @lang = {'id'=> params[:lang], 'packages'=> params[:pack]}
    render :action => :code_update
  end
end
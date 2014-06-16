class RubifyLanguages::AjaxController < ApplicationController  
  include RubifyLanguages
  
  def code_add
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.add(params)
    render :json => {success: true, all: @lang_detail.all}
  end
  
  def code_update
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.update(params)
    render :json => {success: true, all: @lang_detail.all}
  end
  
  def code_delete
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.delete(params[:code])
    render :json => {success: true, all: @lang_detail.all}
  end
  
end
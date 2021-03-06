# Ajax action for Codes Controller
class ExpressTranslate::Ajax::CodesController < ActionController::Base
  
  # Include and require Libraries
  require 'redis'
  require 'json'
  require 'csv'
  include ExpressTranslate
  
  # Load all codes
  def code_load
    load_content_code(params)
  end
  
  # Add code
  # The first: selector LanguageDetail want to add with Language ID and Package ID
  # After: add code for LanguageDetail selected
  # The finally: check status add and show html content for Client is successful or json data is error
  def code_add
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    add = @lang_detail.add(params)
    add['success'] ? load_content_code(params) : (render :json => add)
  end
  
  # Update code
  # The first: selector LanguageDetail want to add with Language ID and Package ID
  # Next step: selector code want to update Text for this
  # Next step: Update if exists data and add for not exists data
  # The finally: show html content for Client
  def code_update
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.find(params[:code]).present? ? @lang_detail.update(params) : @lang_detail.add(params)
    load_content_code(params)
  end
  
  # Delete code
  # The first: selector LanguageDetail want to add with Language ID and Package ID
  # Next step: find and remove code data
  # The finally: show html content for Client
  def code_delete
    @lang_detail = LanguageDetail.info({'id'=> params[:lang], 'packages'=> params[:pack]})
    @lang_detail.delete(params[:code])
    load_content_code(params)
  end
  
  private
  
  # Load html contents code
  # The first: selector Origin language
  # The second: selector Language want to show
  def load_content_code(params)
    @origin_lang = Language.get_origin(params[:pack])
    @lang = {'id'=> params[:lang], 'packages'=> params[:pack]}
    data = []
    LanguageDetail.info(@origin_lang).all.each_with_index do |item, index|
      is_origin = @origin_lang["id"] == @lang["id"]
      code = LanguageDetail.info(@lang).find(item['code']) if !is_origin
      data.push({
        index: index + 1,
        item_code: item["code"],
        item_text: item["text"],
        code_text: is_origin ? item["text"] : (code.present? ? code["text"] : ""),
        origin_lang: is_origin,
        origin_list: is_origin ? "origin_list" : ""
      })
    end
    render json: {success: true, data: data}
  end
end
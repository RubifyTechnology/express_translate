class RubifyLanguages::OptionsController < ApplicationController

  require 'redis'
  require 'json'
  
  include RubifyLanguages
  
  def index
    RubifyLanguages.reset
    RubifyLanguages.seeds
    @packages = Package.all
    render :action => :index, layout: 'rubify_languages/translate'
  end
    
  def languages
    @languages = Package.find(params[:id])['language']
    @max = 0
    @LanguageDetail = LanguageDetail
    @languages.each do |lang|
      lang_detail = LanguageDetail.info(lang)
      tmp_count = lang_detail.all.count
      @max = @max < tmp_count ? tmp_count : @max
    end
    render :action => :languages, layout: 'rubify_languages/translate'
  end
  
  def language_detail
    @languages = Package.find(params[:package])['language']
    @max = 0
    @origin_lang_detail = LanguageDetail.info(@languages[0])
    @languages.each do |lang|
      lang_detail = LanguageDetail.info(lang)
      if @max < lang_detail.all.count
        @max = lang_detail.all.count
        @origin_lang_detail = lang_detail
      end
    end
    
    @lang_detail = LanguageDetail.info({'id'=> params[:id], 'packages'=> params[:package]})
    render :action => :language_detail, layout: 'rubify_languages/translate'
  end
  
  private
  
  def load_all_yaml(lang="en")
    I18n.backend.send(:translations)[lang.to_sym]
  end      
  
end
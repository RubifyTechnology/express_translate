class RubifyLanguages::OptionsController < ApplicationController

  require "redis"
  
  include RubifyLanguages
  
  def index
    puts load_all_languages
    
    render :action => :index, layout: 'rubify_languages/translate'
  end
    
  def translate
    I18n.available_locales
    data = params[:data]
    @trans = load_all_yaml(params[:lang])
    
    if params[:data][:key].scan(/\[\d+\]$/).length == 1
      pos = params[:data][:key].scan(/\[\d+\]$/)[0].gsub(/\[|\]/, "").to_i
      new_key = params[:data][:key].gsub("[#{pos}]", "")
      result_hash = @trans
      exist_key = true
      new_key.split(".").each do |split_key|
        if result_hash and result_hash[split_key.to_sym]
          result_hash = result_hash[split_key.to_sym]
        else
          exist_key = false
        end
      end
      
      if exist_key
        result_hash ||= []
        result_hash[pos] = params[:data][:value]
        result_hash.each_with_index do |el, index|
          result_hash[index] = '' if el.nil?
        end
      else
        arr = ([''] * (pos + 1))
        arr[pos] = params[:data][:value].strip
        Utils.deep_merge!(@trans, Utils.to_deep_hash(new_key => arr))
      end
    else
      Utils.deep_merge!(@trans, Utils.to_deep_hash(params[:data][:key] => params[:data][:value].strip))
    end    
    @trans.deep_stringify_keys!
    res = save_to_file({"#{params[:lang]}" => @trans}, params[:lang])
    I18n.backend.store_translations(params[:lang], @trans)
    I18n.backend.send(:init_translations)
    render :text => res
  end  
  
  def load_language
    lang = params[:lang]
    if I18n.available_locales.include?(lang.to_sym)
      @trans = Utils.to_shallow_hash(load_all_yaml(lang))
      render json: @trans
    else
      render text: 'error'
    end
  end  
  
  private
  
  def load_config
    YAML.load_file(Rails.root.to_s + "/config/rlang.yml")
  end
  
  def db
    config = load_config
    redis = Redis.new(host: config.connect.host, port: config.connect.port, db: config.connect.db)
    puts redis
    redis
  end
  
  def load_all_languages
    redis = db
    redis.set("mykey", "hello world")
    redis.get("mykey")
  end
  
  def save_to_file(obj={},lang="")
    file_url = Rails.root.to_s + "/config/locales/#{lang}.yml"
    f = File.open(file_url, 'w')
    f.write(YAML::dump(obj))
    f.close
    return 'success' 
  end  
    
  def load_all_yaml(lang="en")
    I18n.backend.send(:translations)[lang.to_sym]
  end      
  
end
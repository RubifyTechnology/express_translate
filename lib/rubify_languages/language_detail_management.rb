module RubifyLanguages
  # Construction
  #   code: no_one
  #   text: Number one....
  
  class LanguageDetail < RLangModel
    @name = "lang_package_id"
    @primary = "code"
    @attr = "text"
    
    @lang = {}
    
    def self.info(lang)
      @lang = lang
      self.name = "lang_#{lang['packages']}_#{lang['id']}"
      return self
    end
    
    def self.add(params)
      return self.sync_i18n(params, super(params))
    end
    
    def self.update(params)
      return self.sync_i18n(params, super(params))
    end
    
    def self.delete(code)
      delete = super(code)
      Database.redis.del("#{@lang['packages']}#{@lang['id']}.#{code}") if delete["success"]
      return delete
    end
    
    def self.destroy
      super
      keys = Database.redis.keys([@name, ".*"].join)
      keys.each do |key|
        Database.redis.del(key)
      end
    end
    
    private
    
    def self.sync_i18n(params, check)
      Database.redis.set("#{@lang['packages']}#{@lang['id']}.#{params[:code]}", params[:text].to_json) if check["success"]
      return check
    end
  end
end

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
      add = super(params)
      if add["success"]
        Database.redis.set("#{@lang['packages']}#{@lang['id']}.#{params[:code]}", params[:text].to_json)
      end
      return add
    end
    
    def self.update(params)
      update = super(params)
      if update["success"]
        Database.redis.set("#{@lang['packages']}#{@lang['id']}.#{params[:code]}", params[:text].to_json)
      end
      return update
    end
    
    def self.delete(code)
      delete = super(code)
      if delete["success"]
        Database.redis.del("#{@lang['packages']}#{@lang['id']}.#{code}")
      end
      return delete
    end
    
    def self.destroy
      super
      keys = Database.redis.keys([@name, ".*"].join)
      keys.each do |key|
        Database.redis.del(key)
      end
    end
    
  end
end

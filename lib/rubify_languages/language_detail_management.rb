module RubifyLanguages
  # Construction
  #   id: en
  #   text: English
  
  class LanguageDetail < RLangModel
    @name = "lang_id_package"
    @primary = "code"
    @attr = "text"
    
    def self.info(lang)
      self.name = "lang_#{lang['id']}_#{lang['packages']}"
      return self
    end
  end
end

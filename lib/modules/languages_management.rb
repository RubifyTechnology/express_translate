module RubifyLanguages
  # Construction
  #   id: en
  #   text: English
  #   package: be
  
  class Language < RLangModel
    @name = "languages"
    @primary = "id"
    
    def self.package_text(code)
      puts Package.find(code)
    end
  end
end

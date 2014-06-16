module RubifyLanguages
  # Construction
  #   id: en
  #   text: English
  #   packages: be
  
  class Language < RLangModel
    @name = "languages"
    @primary = "id"
    @attr = "text", "packages"    
  end
end

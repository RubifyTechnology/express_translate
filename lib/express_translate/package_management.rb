module ExpressTranslate
  # Construction
  #   id: be
  #   text: Backend
  
  class Package < RLangModel
    @name = "packages"
    @primary = "id"
    @attr = "text"
    
    @has_many = 'Language'
  end
end

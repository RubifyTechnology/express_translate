module ExpressTranslate
  # Construction
  #   id: be
  #   text: Backend
  
  class Package < ExpressTranslateModel
    @name = "packages"
    @primary = "id"
    @attr = "text"
    
    @has_many = 'Language'
  end
end

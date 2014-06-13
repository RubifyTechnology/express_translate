module RubifyLanguages
  # Construction
  #   id: be
  #   text: Backend
  
  class Package < RLangModel
    @name = "packages"
    @primary = "id"
    @has_many = 'Language'
  end
end

module RubifyLanguages
  class Language
    include RubifyLanguages
    def self.seed
      Language.add({
        id: RubifyLanguages.config["language"]["id"],
        text: RubifyLanguages.config["language"]["text"],
        package: RubifyLanguages.config["package"]["id"]
      })
      
      Language.add({
        id: 'en',
        text: 'English',
        package: 'fe'
      })
      
      Language.add({
        id: 'vn',
        text: 'Vietnamese',
        package: 'fe'
      })
    end
  end
end

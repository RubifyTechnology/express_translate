module RubifyLanguages
  class Language
    include RubifyLanguages
    def self.seed
      Language.add({
        id: RubifyLanguages.config["language"]["id"],
        text: RubifyLanguages.config["language"]["text"],
        packages: RubifyLanguages.config["package"]["id"]
      })
      
      LanguageDetail.name = "lang_#{RubifyLanguages.config["language"]["id"]}_#{RubifyLanguages.config["package"]["id"]}"
      LanguageDetail.add({
        code: 'hello',
        text: 'Hello...'
      })
      
      Language.add({
        id: 'en',
        text: 'English',
        packages: 'fe'
      })
      
      Language.add({
        id: 'vn',
        text: 'Vietnamese',
        packages: 'fe'
      })
      
      Language.add({
        id: 'lao',
        text: 'Laos',
        packages: 'fe'
      })
      
      Language.add({
        id: 'sing',
        text: 'Singapore',
        packages: 'fe'
      })
    end
  end
end

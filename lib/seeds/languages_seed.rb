module RubifyLanguages
  class Language
    include RubifyLanguages
    def self.seed
      Language.add({
        id: RubifyLanguages.config["language"]["id"],
        text: RubifyLanguages.config["language"]["text"],
        packages: RubifyLanguages.config["package"]["id"],
        is_origin: true
      })
      
      LanguageDetail.name = "lang_#{RubifyLanguages.config["language"]["id"]}_#{RubifyLanguages.config["package"]["id"]}"
      LanguageDetail.add({
        code: 'hello',
        text: 'Hello...'
      })
      
      Language.add({
        id: 'en',
        text: 'English',
        packages: 'fe',
        is_origin: true
      })
      
      Language.add({
        id: 'vn',
        text: 'Vietnamese',
        packages: 'fe',
        is_origin: false
      })
      
      Language.add({
        id: 'lao',
        text: 'Laos',
        packages: 'fe',
        is_origin: false
      })
      
      Language.add({
        id: 'sing',
        text: 'Singapore',
        packages: 'fe',
        is_origin: false
      })
    end
  end
end

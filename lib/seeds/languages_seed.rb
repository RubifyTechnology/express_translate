module ExpressTranslate
  class Language
    include ExpressTranslate
    def self.seed
      if !(Language.all.present?)
        Language.add({
          id: ExpressTranslate.config["language"]["id"],
          text: ExpressTranslate.config["language"]["text"],
          packages: ExpressTranslate.config["package"]["id"],
          is_origin: true
        })
      
        LanguageDetail.name = "lang_#{ExpressTranslate.config["language"]["id"]}_#{ExpressTranslate.config["package"]["id"]}"
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
          id: 'vi',
          text: 'Vietnamese',
          packages: 'fe',
          is_origin: false
        })
      
        Language.add({
          id: 'th',
          text: 'Laos',
          packages: 'fe',
          is_origin: false
        })
      
        Language.add({
          id: 'my',
          text: 'Singapore',
          packages: 'fe',
          is_origin: false
        })
      end
    end
  end
end

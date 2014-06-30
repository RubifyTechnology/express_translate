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
      
        LanguageDetail.name = "lang_#{ExpressTranslate.config["package"]["id"]}_#{ExpressTranslate.config["language"]["id"]}"
        LanguageDetail.add({
          code: 'hello',
          text: 'Hello'
        })
      end
    end
  end
end

module RubifyLanguages
  class Language
    include RubifyLanguages
    def self.seed
      Language.add({
        id: RubifyLanguages.config["language"]["id"],
        text: RubifyLanguages.config["language"]["text"],
        package: RubifyLanguages.config["package"]["id"]
      })
    end
  end
end

module RubifyLanguages
  class Package
    include RubifyLanguages
    def self.seed
      if !(Package.all.present?)
        Package.add({
          id: RubifyLanguages.config["package"]["id"],
          text: RubifyLanguages.config["package"]["text"]
        })
        Package.add({
          id: 'fe',
          text: 'Frontend'
        })
      end
    end
  end
end

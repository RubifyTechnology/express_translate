module ExpressTranslate
  class Package
    include ExpressTranslate
    def self.seed
      if !(Package.all.present?)
        Package.add({
          id: ExpressTranslate.config["package"]["id"],
          text: ExpressTranslate.config["package"]["text"]
        })
        Package.add({
          id: 'fe',
          text: 'Frontend'
        })
      end
    end
  end
end

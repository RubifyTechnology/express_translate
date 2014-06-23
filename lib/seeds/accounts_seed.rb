module RubifyLanguages
  class Account
    include RubifyLanguages
    def self.seed
      if !(Account.all.present?)
        RubifyLanguages.config["account"].each do |account|
          Account.add({
            username: account["username"],
            password: account["password"]
          })
        end
      end
    end
  end
end

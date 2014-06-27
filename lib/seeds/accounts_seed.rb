module ExpressTranslate
  class Account
    include ExpressTranslate
    def self.seed
      if !(Account.all.present?)
        ExpressTranslate.config["account"].each do |account|
          Account.add({
            username: account["username"],
            password: account["password"]
          })
        end
      end
    end
  end
end

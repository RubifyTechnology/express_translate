module ExpressTranslate
  # Construction
  #   username: 
  #   password: 
  require "base64"
  
  class Account < ExpressTranslateModel
    @name = "account"
    @primary = "username"
    @attr = "password", "token"
    
    # Modify account when add (Encoding password)
    def self.add(params)
      params[:password] = self.encoding(params[:password])
      super(params)
    end
    
    # Find account with token, check status login bt cookie
    def self.find_by_token(token)
      _find = self.all.select{|s| (s["token"] == token)}
      return _find.count > 0 ? _find[0] : nil
    end
    
    # Ecoding password
    def self.encoding(string)
      encode = Base64.encode64(string)
      encode = encode.split("=").join()
      encode = encode.split("\n").join()
    end
    
    def self.reset
      Database.redis.del("account")
      self.seed
    end
  end
end

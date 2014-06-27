module ExpressTranslate
  # Construction
  #   username: 
  #   password: 
  require "base64"
  
  class Account < RLangModel
    @name = "account"
    @primary = "username"
    @attr = "password", "token"
    
    def self.add(params)
      params[:password] = self.encoding(params[:password])
      super(params)
    end
    
    def self.find_by_token(token)
      _find = self.all.select{|s| (s["token"] == token)}
      return _find.count > 0 ? _find[0] : nil
    end
    
    def self.encoding(string)
      encode = Base64.encode64(string)
      encode = encode.split("=").join()
      encode = encode.split("\n").join()
    end
  end
end

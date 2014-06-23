class RubifyLanguages::BaseController < ActionController::Base
  include RubifyLanguages
  
  def check_authentication
    puts request.headers["HTTP_COOKIE"]
    token_store = getCookie(request.headers["HTTP_COOKIE"], "token")
    return (token_store.present? and Account.find_by_token(token_store).present?)
  end
  
  def getCookie(string, key)
    if string.present?
      string.split(";").each do |cookie|
        cookie.strip!
        _cookie = cookie.split("=")
        if _cookie[0] == key
          return _cookie[1]
        end
      end
    end
    return ""
  end
end
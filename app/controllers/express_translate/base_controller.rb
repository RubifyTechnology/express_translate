class ExpressTranslate::BaseController < ActionController::Base
  include ExpressTranslate

  # Check login status by cookie
  def check_authentication
    token_store = getCookie(request.headers["HTTP_COOKIE"], "token")
    return (token_store.present? and Account.find_by_token(token_store).present?)
  end
  
  # Get cookie form header action
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
class ExpressTranslate::AccountController < ExpressTranslate::BaseController
  before_filter :check_login
  
  include ExpressTranslate
  
  def login
    render layout: 'express_translate/login'
  end
  
  def login_check
    account = Account.find(params[:username])
    if account.present? and account["password"] == Account.encoding(params[:password])
      account["token"] = new_token
      Account.update(account)
      render :json => {success: true, token: account["token"], username: account["username"]}
    else
      render :json => {success: false, error: "Username or password is incorrect!"}
    end
  end
  
  def new_token
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...50).map { o[rand(o.length)] }.join
  end
  
  def check_login
    if check_authentication
      redirect_to controller: "options", action: "index"
    end
  end
end
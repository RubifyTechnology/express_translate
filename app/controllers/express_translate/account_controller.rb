class ExpressTranslate::AccountController < ExpressTranslate::BaseController
  # Check login status for goto page
  before_filter :check_login
  
  include ExpressTranslate
  
  # Login page html code only
  def login
    render layout: 'express_translate/login'
  end
  
  # Login action
  # Find account with username
  # Change exists of account and change password for account (encoding password)
  # If oke, new token for account login and update token for account
  # Render json data for client Successful or Error
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
  
  # Create token for login action, random string
  def new_token
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...50).map { o[rand(o.length)] }.join
  end
  
  # Reset account with url
  def reset
    Account.reset
    redirect_to action: "login"
  end
  
  # Check login status function
  # If logined auto change location for Client
  def check_login
    if check_authentication
      redirect_to controller: "options", action: "index"
    end
  end
end
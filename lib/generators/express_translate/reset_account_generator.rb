module ExpressTranslate
  class ResetAccountGenerator < Rails::Generators::Base    
    include ExpressTranslate
    
    # Reset all account
    # Synchronize account with config file 
    def reset_data
      Account.reset
      puts "Reset account is successful!"
    end
  end
end


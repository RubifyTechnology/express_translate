module ExpressTranslate
  class ResetGenerator < Rails::Generators::Base    
    include ExpressTranslate

    # Clear all data for redis database
    def reset_data
      ExpressTranslate.reset
      puts "Reset successful!"
    end
  end
end


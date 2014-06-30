module ExpressTranslate
  class ResetGenerator < Rails::Generators::Base    
    include ExpressTranslate
    
    def reset_data
      ExpressTranslate.reset
      puts "Reset successful!"
    end
  end
end


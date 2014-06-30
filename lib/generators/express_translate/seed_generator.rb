module ExpressTranslate
  class SeedGenerator < Rails::Generators::Base    
    include ExpressTranslate
    
    def seed_data
      ExpressTranslate.seeds
      puts "Seed data is successful!"
    end
  end
end


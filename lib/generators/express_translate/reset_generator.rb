module ExpressTranslate
  class InstallGenerator < Rails::Generators::Base
    include ExpressTranslate
    def reset_data
      ExpressTranslate.reset
    end
  end
end


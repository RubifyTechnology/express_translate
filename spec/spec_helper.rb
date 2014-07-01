require 'rubygems'
require 'factory_girl'
require 'express_translate'

require 'action_pack'
require 'action_controller'

require_relative '../lib/express_translate'
require_relative '../lib/express_translate/database_management'
require_relative '../lib/express_translate/express_translate_model'
require_relative '../lib/express_translate/language_detail_management'
require_relative '../lib/express_translate/package_management'
require_relative '../lib/express_translate/languages_management'
require_relative '../lib/express_translate/account_management'

require_relative '../app/controllers/express_translate/base_controller'
require_relative '../app/controllers/express_translate/account_controller'
require_relative '../app/controllers/express_translate/files_controller'
require_relative '../app/controllers/express_translate/options_controller'
require_relative '../app/controllers/express_translate/services_controller'

include ExpressTranslate

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  Rails.env = "test"
end

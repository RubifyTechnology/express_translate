Rails.application.routes.draw do
  scope "express_translate" do  
    match "/" => "express_translate/options#index"
    match "/package/:packages" => "express_translate/options#languages"
    match "/language/:package/:id" => "express_translate/options#language_detail" 

    get "/export" => "express_translate/files#export"
    post "/import" => "express_translate/files#import"
    post "/import_yml" => "express_translate/files#import_yml"
    
    get "/login" => "express_translate/account#login"
    post "/login" => "express_translate/account#login_check"
    
    # CODE
    post "/ajax/code/add" => 'express_translate/ajax/codes#code_add'
    post "/ajax/code/update" => 'express_translate/ajax/codes#code_update'
    post "/ajax/code/delete" => 'express_translate/ajax/codes#code_delete'
    
    # LANGUAGE
    post "/ajax/language/add" => 'express_translate/ajax/languages#language_add'
    post "/ajax/language/update" => 'express_translate/ajax/languages#language_update'
    post "/ajax/language/delete" => 'express_translate/ajax/languages#language_delete'
    post "/ajax/language/set_origin" => 'express_translate/ajax/languages#language_set_origin'
    
    # PACKAGE
    post "/ajax/package/add" => 'express_translate/ajax/packages#package_add'
    post "/ajax/package/update" => 'express_translate/ajax/packages#package_update'
    post "/ajax/package/delete" => 'express_translate/ajax/packages#package_delete'
    
    # SERVICE
    get "/service/:packages/:language" => 'express_translate/services#service_language'
    get "/service/:package/" => 'express_translate/services#service_languages'
  end  
end
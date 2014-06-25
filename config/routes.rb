Rails.application.routes.draw do
  scope "rlang" do  
    match "/" => "rubify_languages/options#index"
    match "/package/:packages" => "rubify_languages/options#languages"
    match "/language/:package/:id" => "rubify_languages/options#language_detail" 

    get "/export" => "rubify_languages/options#export"
    post "/import" => "rubify_languages/options#import"
    
    get "/login" => "rubify_languages/account#login"
    post "/login" => "rubify_languages/account#login_check"
    
    # CODE
    post "/ajax/code/add" => 'rubify_languages/options#code_add'
    post "/ajax/code/update" => 'rubify_languages/options#code_update'
    post "/ajax/code/delete" => 'rubify_languages/options#code_delete'
    
    # LANGUAGE
    post "/ajax/language/add" => 'rubify_languages/options#language_add'
    post "/ajax/language/update" => 'rubify_languages/options#language_update'
    post "/ajax/language/delete" => 'rubify_languages/options#language_delete'
    post "/ajax/language/set_origin" => 'rubify_languages/options#language_set_origin'
    
    # PACKAGE
    post "/ajax/package/add" => 'rubify_languages/options#package_add'
    post "/ajax/package/update" => 'rubify_languages/options#package_update'
    post "/ajax/package/delete" => 'rubify_languages/options#package_delete'
    
    # SERVICE
    get "/service/:packages/:language" => 'rubify_languages/services#service_language'
    get "/service/:package/" => 'rubify_languages/services#service_languages'
  end  
end
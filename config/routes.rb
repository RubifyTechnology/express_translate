Rails.application.routes.draw do
  scope "rlang" do  
    match "/" => "rubify_languages/options#index"
    match "/package/:id" => "rubify_languages/options#languages"
    match "/language/:package/:id" => "rubify_languages/options#language_detail" 
    
    post "/ajax/code/add" => 'rubify_languages/ajax#code_add'
    post "/ajax/code/update/:code" => 'rubify_languages/ajax#code_update'
    post "/ajax/code/delete/:code" => 'rubify_languages/ajax#code_delete'
  end  
end
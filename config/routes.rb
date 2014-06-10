Rails.application.routes.draw do
  scope "rlang" do  
    match "/" => "rubify_languages/options#index"
    get "/load_language" , controller: 'rubify_languages/options' , action: 'load_language'
    post "/translate"    , controller: 'rubify_languages/options' , action: 'translate'
  end  
end
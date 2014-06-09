Rails.application.routes.draw do
  scope "itranslate" do  
    match "/" => "rubify_itranslate/itranslate#index"
    get "/load_language" , controller: 'rubify_itranslate/itranslate' , action: 'load_language'
    post "/translate"    , controller: 'rubify_itranslate/itranslate' , action: 'translate'
  end  
end
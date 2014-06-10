Rails.application.routes.draw do
  scope "rlang" do  
    match "" => "rlang/options#index"
    get "" => "rlang/options#index"
    get "/load_language" , controller: 'rlang/options' , action: 'load_language'
    post "/translate"    , controller: 'rlang/options' , action: 'translate'
  end  
end
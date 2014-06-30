class ExpressTranslate::ServicesController < ExpressTranslate::BaseController

  # Require and include Libraries
  require 'redis'
  include ExpressTranslate
  
  # SERVICE
  
  # Get all languages in package with json data
  def service_languages
    respond_to do |format|
      format.json do
        package = Package.find(params[:package])
        render :json => package.present? ? {success: true, languages: package["language"], name: package["text"], id: package["id"]} : {success: false, error: "Package is not found!"}
      end
    end
  end
  
  # Get all data of language with json data
  def service_language
    respond_to do |format|
      format.json do
        @data = {}
        keys = Database.redis.keys("#{params[:packages]}#{params[:language]}.*")
        keys.sort!
        keys.each do |key|
          service_language_detail(key)
        end
        render :json => @data
      end
    end
  end
  
  private
  
  # Convert redis database to json data with key
    # Nnew arrayfor store value level key
      # ex: en.home.hello = "Hello"
        # ["home" => {"hello"=> "Hello"}, {"hello"=> "Hello"}]
    # Set data for array
    # Support multi level keys
  def service_language_detail(key)
    path = key.split(".")
    i = path.count - 1
    items = [i]
    items[i-1] = {"#{path[i]}"=> Database.redis.get(key)}
    i-=1
    while i > 0 do
      items[i-1] = {"#{path[i]}"=> items[i]}
      i-=1
    end
    extendObjects(@data, items[0])
  end
  
  # Function for convert redis database to json data (support multi level)
    # Check type of old data
      # String: extend value
      # Object: add attribute for object
      # Nil: add attribute for object
    # If type of old and new data is Object
      # Extend new object for old object
  # Description:
    #obj1: old object
    #obj2: new object
  # Return: Object
  def extendObjects(obj1, obj2)
    if obj1.is_a?(String)
      if obj2.is_a?(String)
        obj1 = obj2
      elsif obj2.is_a?(Object)
        obj2.each do |key2, val2|
          obj1 = {}
          obj1[key2] = val2
        end
      end
    elsif obj1.is_a?(Object) and obj2.is_a?(Object)
      obj2.each do |key2, val2|
        if obj1[key2].nil?
          obj1[key2] = obj2[key2]
        else
          obj1[key2] = extendObjects(obj1[key2], obj2[key2])
        end        
      end
    end
    return obj1
  end  
end
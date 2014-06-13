module RubifyLanguages
  # Construction
  #   id: xyz
  #   ......
  #   ......
  
  class RLangModel
    class << self; attr_accessor :name, :primary end
    @name = "rlang"
    @primary = "id"
    @has_many = ''
      
    def self.all
      data = Database.get(@name)
      data = data.nil? ? [] : (data.is_a?(Array) ? data : [].push(data))
      add_has_many(data)
      data
    end
    
    def self.save(obj)
      Database.set(@name, obj)
    end
    
    def self.destroy
      Database.del(@name)
    end
    
    def self.add(params)
      data = self.all.push(params)
      self.save(data)
    end
    
    def self.delete(id)
      data = self.all
      data.reject!{|package| package[@primary] == id}
      self.save(data)
    end
    
    def self.update(params)
      data = self.all
      data.reject!{|package| package[@primary] == params[@primary]}
      data.push(params)
      self.save(data)
    end
    
    def self.find(code)
      data = self.all
      search = data.select{|package| package[@primary] == code}
      return (search.count > 0) ? search[0] : ""
    end
    
    private
    
    def add_has_many(items)
      @has_many.each do |model_many_item|
        items.each do |item|
          add_has_many_item(item, model_many_item)
        end
      end
    end
    
    def add_has_many_item(item, model_many)
      item[model_many] = model_many.constantize.all.select{|i| i[@name] == item[@primary]}
    end
  end
end
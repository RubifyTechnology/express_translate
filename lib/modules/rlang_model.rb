module RubifyLanguages
  # Construction
  #   id: xyz
  #   ......
  #   ......
  
  class RLangModel
    class << self; attr_accessor :name, :primary end
    @name = "rlang"
    @primary = "id" 
      
    def self.all
      Database.get(@name) || []
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
  end
end
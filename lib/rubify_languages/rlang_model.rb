module RubifyLanguages
  # Construction
  #   id: xyz
  #   ......
  #   ......
  
  class RLangModel

    class << self; attr_accessor :name, :primary, :has_many, :attr end
    # attr_accessor :
    @has_many = []
    @name = "rlang"
    @primary = "id"
    @attr = ""
    
    def self.all
      data = Database.get(@name)
      data = data.nil? ? [] : (data.is_a?(Array) ? data : [].push(data))
      self.add_has_many(data)
      data
    end
    
    def self.save(obj)
      Database.set(@name, self.protect_attr_items(obj))
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
      if (search.count > 0)
        self.add_has_many_item(search[0])
      else
        search = [nil]
      end
      return search[0]
    end
    
    private
    
    def self.protect_attr_items(items)
      items_copy = []
      items.each do |item|
        items_copy.push(self.protect_attr(item))
      end
      return items_copy
    end
    
    def self.protect_attr(item)
      item = JSON.parse(item.to_json)
      item_copy = {}
      item_copy[@primary] = item[@primary]
      if @attr.present?
        @attr = @attr.is_a?(Array) ? @attr : [@attr]
        @attr.each do |attr|
          item_copy[attr] = item[attr]
        end
      end
      return item_copy
    end
    
    def self.add_has_many(items)
      items.each do |item|
        self.add_has_many_item(item)
      end
    end
    
    def self.add_has_many_item(item)
      if @has_many.present?
        @has_many = @has_many.is_a?(Array) ? @has_many : [@has_many]
        @has_many.each do |model_many_item|
          if model_many_item.present?
            item[model_many_item.downcase] = RubifyLanguages.const_get(model_many_item).all.select{|i| i[@name] == item[@primary]}
          end
        end
      end
    end
    
  end
end
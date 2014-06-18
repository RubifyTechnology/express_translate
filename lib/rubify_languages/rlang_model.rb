module RubifyLanguages
  # Construction
  #   id: xyz
  #   ......
  #   ......
  
  class RLangModel

    class << self; attr_accessor :name, :primary, :has_many, :attr, :unique end
    # attr_accessor :
    @has_many = []
    @name = "rlang"
    @primary = "id"
    @attr = ""
    @unique = ""
    
    def self.all
      data = Database.get(@name)
      data = data.nil? ? [] : (data.is_a?(Array) ? data : [].push(data))
      self.add_has_many(data)
      data.sort_by!{|item| item.first}
      data
    end
    
    def self.save(obj)
      Database.set(@name, self.protect_attr_items(obj))
    end
    
    def self.destroy
      Database.del(@name)
    end
    
    def self.add(params)
      if JSON.parse(params.to_json)[@primary] == ""
        return {"success" => false, "error" => "Primary data is nil!"}
      end
      if self.check_unique_allow_add(params)
        data = self.all.push(params)
        self.save(data)
        return {"success" => true, "#{@name}" => data}
      else
        return {"success" => false, "error" => "Duplicate primary key"}
      end
    end
    
    def self.delete(id)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == id}
      count_after = all.count
      if count_before > count_after
        self.save(all)
        return {"success" => true, "#{@name}" => all}
      else
        return {"success" => false, "error" => "Data is not found!"}
      end
    end
    
    def self.update(params)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == params[@primary]}
      count_after = all.count
      if count_before > count_after
        all.push(params)
        self.save(all)
        return {"success" => true, "#{@name}" => all}
      else
        return {"success" => false, "error" => "Data is not found!"}
      end
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
    
    def self.check_unique_allow_add(item)
      if @unique.present?
        @unique = @unique.is_a?(Array) ? @unique : [@unique]
        check_unique = false
        @unique.each do |unique|
          select_check = self.all.select{|i| (i[unique] == item[unique]) and i[@primary] == item[@primary]}
          check_unique = true if select_check.count == 0
        end
        return check_unique
      else
        find = self.find(item[@primary])
        if find.present?
          return false
        end
        return true
      end
    end
    
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
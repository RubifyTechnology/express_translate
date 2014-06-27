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
        return self.primary_nil
      end
      if self.check_unique_allow_add(params)
        data = self.all.push(params)
        self.save(data)
        return self.successful(data)
      else
        return self.primary_key
      end
    end
    
    def self.delete(id)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == id}
      return self.change_data(count_before, all.count, all)
    end
    
    def self.update(params)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == params[@primary]}
      count_after = all.count
      all.push(params) if count_before > count_after
      return self.change_data(count_before, count_after, all)
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
        return self.find(item[@primary]).nil?
      end
    end
    
    def self.protect_attr_items(items)
      items_copy = []
      items.each do |item|
        items_copy.push(self.protect_attr(item)) if item.present?
      end
      return items_copy
    end
    
    def self.protect_attr(item)
      if item.to_json == ""
        puts item.inspect
        return nil
      end
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
    
    # Return
    
    def self.change_data(before, after, data)
      if before > after
        self.save(data)
        return self.successful(data)
      else
        return self.notfound
      end
    end
    
    def self.notfound
      return {"success"=> false, "error"=> "Data is not found!"}
    end
    
    def self.primary_key
      return {"success" => false, "error" => "Duplicate primary key"}
    end
    
    def self.primary_nil
      return {"success" => false, "error" => "Primary data is nil!"}
    end
    
    def self.successful(data)
      return {"success" => true, "#{@name}" => data}
    end
  end
end
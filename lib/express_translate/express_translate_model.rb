module ExpressTranslate
  # Construction
  #   id: xyz
  #   ......
  #   ......
  
  class ExpressTranslateModel

    class << self; attr_accessor :name, :primary, :has_many, :attr, :unique end
    # attr_accessor :
    # Config for item
    @has_many = []
    @name = "express_translate"
    @primary = "id"
    @attr = ""
    @unique = ""
    
    # get all item in table
    def self.all
      data = Database.get(@name)
      data = data.nil? ? [] : (data.is_a?(Array) ? data : [].push(data))
      self.add_has_many(data)
      data.sort_by!{|item| item.first}
      data
    end
    
    # Save obj to redis database
    # Synchronize data to redis database
    def self.save(obj)
      Database.set(@name, self.protect_attr_items(obj))
    end
    
    # Clear all data of table
    def self.destroy
      Database.del(@name)
    end
    
    # Add item with params
    # Check primary key for present
    # Check unique data
    # Return messages
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
    
    # Delete item by id
    # Remove item with primary key
    def self.delete(id)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == id}
      return self.change_data(count_before, all.count, all)
    end

    # Update item by params
    # Remove old item
    # Add new item with exsits data
    # Return json data for status
    def self.update(params)
      all = self.all
      count_before = all.count
      all.reject!{|package| package[@primary] == params[@primary]}
      count_after = all.count
      all.push(params) if count_before > count_after
      return self.change_data(count_before, count_after, all)
    end
    
    # Find item by code
    # Select item with primary key
    # return limit items selected
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
    
    # Check duplicate primary key or list unique
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
    
    # Check attributes for allow store for list items
    def self.protect_attr_items(items)
      items_copy = []
      items.each do |item|
        items_copy.push(self.protect_attr(item)) if item.present?
      end
      return items_copy
    end
    
    # Check attributes for allow store only one item
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
    
    # Add relationship for model for item list
    def self.add_has_many(items)
      items.each do |item|
        self.add_has_many_item(item)
      end
    end
    
    # Add relationship for model only one item
    def self.add_has_many_item(item)
      if @has_many.present?
        @has_many = @has_many.is_a?(Array) ? @has_many : [@has_many]
        @has_many.each do |model_many_item|
          if model_many_item.present?
            item[model_many_item.downcase] = ExpressTranslate.const_get(model_many_item).all.select{|i| i[@name] == item[@primary]}
          end
        end
      end
    end
    
    # Return messages
    
    # Messages for change data
    def self.change_data(before, after, data)
      if before > after
        self.save(data)
        return self.successful(data)
      else
        return self.notfound
      end
    end

    # Messages for not found data
    def self.notfound
      return {"success"=> false, "error"=> "Data is not found!"}
    end
    
    # Messages for duplicate primary key
    def self.primary_key
      return {"success" => false, "error" => "Duplicate primary key"}
    end
    
    # Messages for primary key is nil
    def self.primary_nil
      return {"success" => false, "error" => "Primary data is nil!"}
    end
    
    # Messages for successful
    def self.successful(data)
      return {"success" => true, "#{@name}" => data}
    end
  end
end
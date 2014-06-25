module RubifyLanguages
  # Construction
  #   id: en
  #   text: English
  #   packages: be
  
  class Language < RLangModel
    @name = "languages"
    @primary = "id"
    @attr = "text", "packages", "is_origin"

    @unique = "id", "packages"
    
    def self.delete_by_id_packages(id, packages)
      all = self.all
      count_before = all.count
      all.reject!{|lang| (lang["id"] == id and lang["packages"] == packages)}
      count_after = all.count
      if count_before > count_after
        self.save(all)
        return {"success"=> true, "#{@name}" => all}
      else
        return {"success"=> false, "error"=> "Data is not found!"}
      end
    end
    
    def self.update_by_id_packages(old_id, packages, params)
      all = self.all
      scan = all.select{|lang| (lang["id"] == params[:id] and lang["packages"] == packages)}
      if scan.count == 0
        count_before = all.count
        all.reject!{|lang| (lang["id"] == old_id and lang["packages"] == packages)}
        count_after = all.count
        if count_before > count_after
          self.save(all)
          update = self.add(params)
          if update["success"]
            self.check_update_data(old_id, packages, params)
          end
          return update
        else
          return {"success"=> false, "error"=> "Data is not found!"}
        end
      else
        return {"success" => false, "error" => "Duplicate primary key"}
      end
    end
    
    def self.set_origin(id, packages)
      check = false
      all = self.all
      all.each do |lang|
        if lang["packages"] == packages
          lang["is_origin"] = false
          if (lang["id"] == id)
            lang["is_origin"] = true
            check = true
          end
        end
      end
      self.save(all)
      if check
        return {"success"=> true, "#{@name}" => all}
      else
        return {"success"=> false, "error"=> "Data is not found!"}
      end
    end
    
    def self.get_origin(packages)
      origin = self.all.select{|lang| (lang["packages"] == packages and lang["is_origin"] == true)}
      if origin.count > 0
        return origin[0]
      else
        all_of_package = self.all.select{|lang| lang["packages"] == packages}
        if (all_of_package.count > 0)
          self.set_origin(all_of_package[0]["id"], packages)
          return all_of_package[0]
        else
          return nil
        end
      end
    end
    
    private

    def self.check_update_data(old_id, packages, params)
      if old_id != params[:id]
        lang_detail_old = "lang_#{packages}_#{old_id}"
        lang_detail_new = "lang_#{packages}_#{params[:id]}"
        Database.redis.set(lang_detail_new, Database.redis.get(lang_detail_old))
        Database.redis.del(lang_detail_old)
        
        keys = Database.redis.keys("#{packages}#{old_id}.*")
        keys.each do |key|
          key_array = key.split(".")
          key_array[0] = "#{packages}#{params[:id]}"
          Database.redis.set(key_array.join("."), Database.redis.get(key))
          Database.redis.del(key)
        end
      end
    end
  end
end

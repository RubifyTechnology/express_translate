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
      if count_before > all.count
        self.save(all)
        return self.successful(all)
      end
      return self.notfound
    end
    
    def self.update_by_id_packages(old_id, packages, params)
      all = self.all
      if self.get_with_id_packages(params[:id], packages).nil?
        count_before = all.count
        all.reject!{|lang| (lang["id"] == old_id and lang["packages"] == packages)}
        if count_before > all.count
          self.save(all)
          update = self.add(params)
          self.check_update_data(old_id, packages, params) if update["success"]
          return update
        end
        return self.notfound
      end
      return self.primary_key
    end
    
    def self.set_origin(id, packages)
      all = self.all
      origin_old = self.get_origin(packages)
      if origin_old.present?
        origin_old["is_origin"] = false
        self.update_by_id_packages(origin_old["id"], packages, origin_old)
      end
      
      origin_new = self.get_with_id_packages(id, packages)
      if origin_new.present?
        origin_new["is_origin"] = true
        self.update_by_id_packages(origin_new["id"], packages, origin_new)
        return self.successful(all)
      end

      return self.notfound
    end
    
    def self.get_origin(packages)
      origin = self.all.select{|lang| (lang["packages"] == packages and lang["is_origin"] == true)}
      return origin[0] if origin.count > 0
      return self.get_origin_part_1(packages)
    end
    
    def self.get_with_id_packages(id, packages)
      selects = self.all.select{|lang| (lang["id"] == id and lang["packages"] == packages)}
      return selects.count > 0 ? selects[0] : nil
    end
    
    private
    
    def self.get_origin_part_1(packages)
      all_of_package = self.all.select{|lang| lang["packages"] == packages}
      if (all_of_package.count > 0)
        self.set_origin(all_of_package[0]["id"], packages)
        return all_of_package[0]
      end
      return nil
    end

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

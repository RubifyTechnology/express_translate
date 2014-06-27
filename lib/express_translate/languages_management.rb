module ExpressTranslate
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
      return self.reject_with_id_packages(id, packages)
    end
    
    def self.update_by_id_packages(old_id, packages, params)
      all = self.all
      return self.primary_key if self.get_with_id_packages(params[:id], packages).present?
      return self.notfound if self.reject_with_id_packages(old_id, packages)["success"].present?
      return self.check_update_data(old_id, packages, params, self.add(params))  
    end
    
    def self.set_origin(id, packages)
      all = self.all
      origin_old = self.get_origin(packages)
      self.update_origin_only(origin_old["id"], packages, false) if origin_old.present?
      origin_new = self.get_with_id_packages(id, packages)      
      if origin_new.present?
        self.update_origin_only(origin_new["id"], packages, true)
        return self.successful(all)
      end
      return self.notfound
    end
    
    def self.get_origin(packages)
      origin = self.all.select{|lang| (lang["packages"] == packages and lang["is_origin"] == true)}
      return origin[0] if origin.count > 0
      return self.get_origin_part_1(packages)
    end
    
    private
    
    def self.reject_with_id_packages(id, packages)
      all_reject = self.all
      count_before = all_reject.count
      all_reject.reject!{|lang| (lang["id"] == id and lang["packages"] == packages)}
      return self.change_data(count_before, all_reject.count, all_reject)
    end
    
    def self.update_origin_only(id, packages, is_true)
      this = self.get_with_id_packages(id, packages)
      this["is_origin"] = is_true
      self.save(self.all.push(this)) if self.reject_with_id_packages(id, packages)["success"]
    end
    
    def self.get_origin_part_1(packages)
      all_of_package = self.all.select{|lang| lang["packages"] == packages}
      if (all_of_package.count > 0)
        self.set_origin(all_of_package[0]["id"], packages)
        return all_of_package[0]
      end
      return nil
    end

    def self.check_update_data(old_id, packages, params, update)
      if old_id != params[:id] and update["success"]
        lang_detail_old = ["lang", packages, old_id].join("_")
        lang_detail_new = ["lang", packages, params[:id]].join("_")
        Database.redis.set(lang_detail_new, Database.redis.get(lang_detail_old))
        Database.redis.del(lang_detail_old)      
        keys = Database.redis.keys("#{packages}#{old_id}.*")
        self.updating_keys(keys, packages, params)
      end
      return update
    end
    
    def self.updating_keys(keys, packages, params)
      keys.each do |key|
        key_array = key.split(".")
        key_array[0] = [packages, params[:id]].join
        Database.redis.set(key_array.join("."), Database.redis.get(key))
        Database.redis.del(key)
      end
    end
    
    def self.get_with_id_packages(id, packages)
      selects = self.all.select{|lang| (lang["id"] == id and lang["packages"] == packages)}
      return selects.count > 0 ? selects[0] : nil
    end
    
  end
end
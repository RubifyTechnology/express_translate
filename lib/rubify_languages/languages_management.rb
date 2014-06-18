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
    
    def self.update_by_id_packages(id, packages, params)
      all = self.all
      count_before = all.count
      all.reject!{|lang| (lang["id"] == id and lang["packages"] == packages)}
      count_after = all.count
      if count_before > count_after
        self.save(all)
        return self.add(params)
      else
        return {"success"=> false, "error"=> "Data is not found!"}
      end
    end
    
    def self.set_origin(id, packages)
      check = false
      all = self.all
      all.each do |lang|
        lang["is_origin"] = false
        if (lang["id"] == id and lang["packages"] == packages)
          lang["is_origin"] = true
          check = true
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
    
  end
end

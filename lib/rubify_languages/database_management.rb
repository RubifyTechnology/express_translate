module RubifyLanguages
  class Database
    include RubifyLanguages
    def self.redis
      @redis = Redis.new(host: RubifyLanguages.config["connect"]["host"], port: RubifyLanguages.config["connect"]["port"], db: RubifyLanguages.config["connect"]["db"])
    end
    
    def self.set(key, obj)
      self.redis.set(key, obj.to_json)
    end
    
    def self.get(key)
      self.redis.get(key) ? JSON.parse(self.redis.get(key)) : nil
    end
    
    def self.del(key)
      self.redis.del(key)
    end
    
    def self.clear
      self.redis.keys("*").each do |key|
        self.redis.del(key)
      end
    end
  end
end
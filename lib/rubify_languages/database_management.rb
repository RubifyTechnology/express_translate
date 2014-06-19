module RubifyLanguages
  class Database
    include RubifyLanguages
    require 'redis'
    
    def self.redis
      @redis = Redis.new(host: RubifyLanguages.config["connect"]["host"], port: RubifyLanguages.config["connect"]["port"], db: RubifyLanguages.config["connect"]["db"])
    end
    
    def self.set(key, obj)
      self.redis.set(key, obj.to_json)
    end
    
    def self.get(key)
      data = self.redis.get(key)
      data = JSON.parse(data) if data.present?
      data
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

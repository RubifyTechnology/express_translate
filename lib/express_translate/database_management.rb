module ExpressTranslate
  class Database
    include ExpressTranslate
    require 'redis'
    
    def self.redis
      host = ExpressTranslate.config["connect"]["host"]
      port = ExpressTranslate.config["connect"]["port"]
      db = ExpressTranslate.config["connect"]["db"]
      password =ExpressTranslate.config["connect"]["password"]
      
      @redis ||= Redis.new(:url => "redis://:#{password}@#{host}:#{port}/#{db}")
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
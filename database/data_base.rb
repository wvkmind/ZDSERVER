require 'rubygems'
require 'eventmachine'
require "redis"
require 'singleton'

class DataBase
    include Singleton
    public
    def initialize
        @redis = Redis.new(host: NetConfig::REDIS_IP, port: NetConfig::REDIS_PORT)
        super
    end
    def redis
        @redis
    end
    def self._redis_
        DataBase.instance.redis
    end
end 

require 'rubygems'
require 'eventmachine'
require "redis"
require 'singleton'
#我们的数据在大的范围内只做存入和检出，逻辑上减少逻辑数据库的查询
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

require 'rubygems'
require 'eventmachine'
require "redis"
require 'singleton'
require 'yaml'
require 'active_record'

#我们的数据在大的范围内只做存入和检出，逻辑上减少逻辑数据库的查询

db_conf = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(db_conf)

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

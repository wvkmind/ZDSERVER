require 'rubygems'
require 'eventmachine'
require "redis"
require 'singleton'

module DataBase
    class D
        include Singleton
        public
        def initialize
            @redis = Redis.new(:host => "127.0.0.1", :port => 6666)
            super
        end
        def redis
            @redis
        end
    end 
    def self._redis_
        DataBase::D.instance.redis
    end
end
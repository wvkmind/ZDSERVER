require 'rubygems'
require 'eventmachine'
require "redis"
require 'singleton'

module D
    class DB
		include Singleton
		public
		def initialize
            @redis = Redis.new(:host => "127.0.0.1", :port => 6666)
      		super
		end
    end
end

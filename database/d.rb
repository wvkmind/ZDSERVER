require 'rubygems'
require 'eventmachine'
require 'mysql2/em'
require 'singleton'

module D
    def self.connect(host,username,password,database)
        D::DB.instance.connect(host,username,password,database)
    end
    
    def self.query(str)
        D::DB.instance.query(str)
    end
	
    class DB
		include Singleton
		public
		def initialize
            @_database = nil
      		super
		end

        def connect(host,username,password,database)
            @mysql_client = Mysql2::EM::Client.new(host: host,username: username,password: password)
            @mysql_client.query("use #{database};")
        rescue Mysql2::Error => error
            puts error
        rescue Exception => error
            puts error
        end

        def query(str)
             @mysql_client.query(str)
        rescue Mysql2::Error => error
            puts error
        rescue Exception => error
            puts error
        end 

    end

end

def test
    D.connect('localhost','root',123456,'pcia')
    ret = D.query('select * from users limit 1;')
    ret.each do |r|
        puts r['account']
    end
end

#test
class User < ActiveRecord::Base
	self.table_name = "users"
	self.primary_key = "id"
	@@user_mem = {}
	def to_h
		{
			status: 0,
			id: self[:id],
			account: self[:account]
		}
	end
	def self.user_mem
		@@user_mem
	end
	def self.login(user)
        @@user_mem[user[:id]] = user
    end
    def self.loginout(id)
        @@user_mem.delete(id)
    end
    def self.get_user(id)
        @@user_mem[id]
    end

end
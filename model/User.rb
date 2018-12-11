class User < BaseModel
	self.table_name = "users"
	self.primary_key = "id"
	@@user_mem = {}
	def to_h
		{
			id: self[:id],
			account: self[:account]
		}
	end

	def deleted?
        status!=0
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
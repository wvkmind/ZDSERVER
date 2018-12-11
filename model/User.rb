class User < BaseModel
	self.table_name = "users"
    self.primary_key = "id"
	def to_h
		{
			id: self[:id],
			account: self[:account]
		}
	end

	def deleted?
        status!=0
	end

end
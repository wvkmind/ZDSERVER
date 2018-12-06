class User < BaseModel
	def not_null
		[:account]
	end

	def uniq_vlaue
		[:account]
	end

	def to_h
		{
			id: self[:id],
			account: self[:account]
		}
	end

	def deleted?
        self[:status]!=0
    end
end
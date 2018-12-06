class User < BaseModel
	def not_null
		[:account]
	end

	def uniq_vlaue
		[:account]
	end
end
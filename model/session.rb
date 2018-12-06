class Session 
    def not_null
		[:account]
	end

	def uniq_vlaue
		[:account]
    end
    def self.update_session(account, token)
        session = Session.find_by(:account, account)[0]
        if session.nil?
            session = Session.create account: account, token:token
        elsif session.token.blank?
            session[:token] = token
            session.save
        end
        session
    end
end
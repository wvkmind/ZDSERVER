class Session < BaseModel
    self.table_name = "sessions"
    self.primary_key = "id"
    def self.update_session(account, token)
        session = Session.find_by_account(account)
        if session.nil?
            session = Session.create account: account, token:token
        elsif session[:token].nil?
            session[:token] = token
            session.save
        end
        session
    end
end
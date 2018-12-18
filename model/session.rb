class Session < ActiveRecord::Base
    self.table_name = "sessions"
    self.primary_key = "id"
    @@session_mem = {}
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
    def self.session_mem
        @@session_mem
    end
    def self.login(session,user_id)
        @@session_mem[session[:account]] = {token: session[:token],user_id: user_id}
    end
    def self.loginout(account)
        @@session_mem.delete(account)
    end
    def self.get_session(account)
        @@session_mem[account]
    end
end

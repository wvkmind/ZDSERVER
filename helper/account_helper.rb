module AccountHelper
    def self.login(account, password)
        raise ServerException.new('Account or password not provied.') if account.nil? or password.nil?
        user = User.find_by_account(account)
        raise ServerException.new('Account doesnot exists.') if user.nil?
        hashed_password = hash_password password, user[:salt]
        ret = nil
        if bytes_equal? hashed_password.bytes, user[:hashed_password].bytes
          token = SecureRandom.uuid
          ret = {session: Session.update_session(account, token),user: user}
        else
          raise ServerException.new('Wrong password.')
        end
        ret
    end

    def self.generate_password(password)
        salt = generate_salt
        {salt:salt,hash_password:hash_password(password, salt)}
    end
    private

    def self.generate_salt
        SecureRandom.base64(16)
    end

    def self.hash_password(pass, salt)
        digest = Digest::SHA256.new
        digest.reset
        digest.update(Base64.decode64(salt))
        
        hashed = digest.update(pass).base64digest
      
        hashed
    end
  
    def self.bytes_equal?(a, b)
        ret = a.size == b.size
        a.each_with_index {|aa, i| ret &= aa == b[i]}
        ret
    end
end
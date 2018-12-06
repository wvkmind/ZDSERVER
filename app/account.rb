Net::Connector.registergate('register',-> params,gete do
    begin
        user = nil
        if(params['id'].nil?)
            user = User.new
            user[:account]=params['account']
        else 
            user = User.find_by_id(params['id'])
        end
        if(params['status']==0)
            ps = AccountHelper.generate_password(params['password'])
            user[:hashed_password]=ps[:hash_password].to_s
            user[:salt]=ps[:salt].to_s
        end
        user[:status]=params['status']
        user.save
        gete.send(user.to_h,params)
    rescue Exception => e
        gete.send({error:e.message},params)
    end
end)

Net::Connector.registergate('login',-> params,gete do
    begin
        ret = AccountHelper::login params['account'], params['password']
        session = ret[:session]
        user = ret[:user]
        node = gete.insert_available_node(user[:id])
        if node == nil
            session[:token] = Base64.encode64("#{session[:account]}:#{session[:token]}").gsub("\n", '').strip
            session[:ip] = node.ip
            session[:port] = node.port
            node.flush_heartbeat(user[:id])
            gete.send(session.to_h,params)
        else
            raise Exception.new('Server is full.')
        end
    rescue Exception => e
        gete.send({error:e.message},params)
    end
end)
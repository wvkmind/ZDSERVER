Net::Connector.registergate('register',-> params,gete do
    begin
        user = nil
        if(params['id'].nil?)
            user = User.new
            user[:account]=params['account']
        else 
            user = User.find_by_id(params['id'])
        end
        if(params['status']==0||params['status'].nil?)
            ps = AccountHelper.generate_password(params['password'])
            user[:hashed_password]=ps[:hash_password].to_s
            user[:salt]=ps[:salt].to_s
            user[:status] = 0
        end
        raise 'Must have passwrod.' if user[:hashed_password].nil?
        user[:status]=params['status'] unless params['status'].nil?
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
        if node != nil
            session[:token] = Base64.encode64("#{session[:account]}:#{session[:token]}").gsub("\n", '').strip
            raise Exception.new('This account has already been logged in.') unless node.init_heartbeat(user[:id],params[:ip],params[:port])
            User.login(user)
            Session.login(session,user[:id])
            gete.send({time: params['time'],ip: node.ip,port: node.port,token:session[:token]},params)
        else
            raise Exception.new('Server is full.')
        end
    rescue Exception => e
        puts e.message
        puts e.backtrace
        gete.send({error:e.message},params)
    end
end)
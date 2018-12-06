Net::Connector.registergate('register',-> params,node do
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
        node.send(user.to_h,params)
    rescue Exception => e
        node.send({error:e.message},params)
    end
end)
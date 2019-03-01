Net::Connector.registergate('register',-> params,gete do
    begin
        User.transaction do
            raise '账号已存在' if(User.find_by_account params['account'])
            raise '名字已存在' if(User.find_by_name params['name'])
            user = User.new
            user[:account]=params['account']
            ps = AccountHelper.generate_password(params['password'])
            user[:hashed_password]=ps[:hash_password].to_s
            user[:salt]=ps[:salt].to_s
            user[:status] = 0
            raise '密码呢' if user[:hashed_password].nil?
            user[:status]=params['status'] unless params['status'].nil?
            raise ServerException.new('没有选人呀') if params['type'].nil?
            user[:name]=params['user_name'].to_s
            user[:type]=params['type'].to_i
            user[:tra_rate]=params['tra_rate'].to_i
            user[:phy_str_rate]=params['phy_str_rate'].to_i
            user[:exp_rate]=params['exp_rate'].to_i
            raise ServerException.new("你想干啥") if user[:tra_rate] + user[:phy_str_rate] + user[:exp_rate] > 5
            user[:level]=1
            user[:zhanyang]=0
            user[:buliang]=0
            user.save
            gete.send(user.to_h,params)
        end
    rescue Exception => e
        gete.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registergate('login',-> params,gete do
    ret = AccountHelper::login params['account'], params['password']
    session = ret[:session]
    user = ret[:user]
    User.login(user)
    Session.login(session,user[:id])
    node = gete.insert_available_node(user[:id])
    if node != nil
        raise ServerException.new('登录失败') unless (node.init_heartbeat(user[:id],params[:ip],params[:port]))
        session[:token] = Base64.encode64("#{session[:account]}:#{session[:token]}").gsub("\n", '').strip
        Room.out_room(user[:id])
        gete.send(
            {
                status: 0,
                time: params['time'],
                ip: node.ip,
                port: node.port,
                token:session[:token],
                user:user.to_client
            },
            params
        )
    else
        raise ServerException.new('服务器好像满了')
    end
end)

Net::Connector.registergate('login_out',-> params,gete do
    ret = AccountHelper::login params['account'], params['password']

    session = ret[:session]
    user = ret[:user]
    User.loginout(user.id)
    Session.loginout(params['account'])

end

#位置改变
Net::Connector.registerlogic('cp',-> params,my_node do
    user = User.get_user(params[:user_id])
    user.tilizhi = params['tl']
    user.set_room_pos(params['cp_data'])
    Room.send_data(params[:user_id],{cp_data:params['cp_data'],tl:params['tl']}.merge({id: params[:user_id]}),params)
end)

#表情
Net::Connector.registerlogic('exp',-> params,my_node do
    user = User.get_user(params[:user_id])
    a = user.room_pos
    a[0] = params['ac_data'][0]
    a[1] = params['ac_data'][1]
    a[2] = params['ac_data'][2]
    a[3] = params['ac_data'][0]
    a[4] = params['ac_data'][1]
    user.set_room_pos(a)
    Room.send_data(params[:user_id],{ac_data:params['ac_data']}.merge({id: params[:user_id]}),params)
end)

#增加体力值
Net::Connector.registerlogic('atlz',-> params,my_node do
    user = User.get_user(params[:user_id])
    user.add_tilizhi(params[:n])
end)
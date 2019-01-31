
#位置改变
Net::Connector.registerlogic('cp',-> params,my_node do
    begin
        user = User.get_user(params[:user_id])
        user.set_room_pos(params['cp_data'])
        Room.send_data(params[:user_id],{cp_data:params['cp_data']}.merge({id: params[:user_id]}),params)
    rescue Exception => e
        Room.out_room(params[:user_id])
        my_node.send({status: 1,error:e.message},params)
    end
end)

#表情
Net::Connector.registerlogic('ac',-> params,my_node do
    begin
        user = User.get_user(params[:user_id])
        user.set_room_pos(params['ac_data'])
        Room.send_data(params[:user_id],{ac_data:params['ac_data']}.merge({id: params[:user_id]}),params)
    rescue Exception => e
        Room.out_room(params[:user_id])
        my_node.send({status: 1,error:e.message},params)
    end
end)
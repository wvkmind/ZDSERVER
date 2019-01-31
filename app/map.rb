Net::Connector.registerlogic('talk',-> params,my_node do
    begin
        user = User.get_user(params[:user_id])
        Room.send_data(params[:user_id],{talk:params['talk']}.merge({id: params[:user_id]}),params)
    rescue Exception => e
        Room.out_room(params[:user_id])
        my_node.send({status: 1,error:e.message},params)
    end
end)
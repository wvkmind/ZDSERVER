Net::Connector.registerlogic('talk',-> params,my_node do
    begin
        user = User.get_user(params[:user_id])
        Room.talk(params[:user_id],params['talk'])
        Room.send_data(params[:user_id],{talk:params['talk']}.merge({id: params[:user_id]}),params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('pick',-> params,my_node do
    begin
        Room.pick_items(params[:user_id],params['pos'].to_i)
        Room.send_data(user_id,{items:map.get_items,user_id: params[:user_id]},params) 
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('eat',-> params,my_node do
    begin
        if Room.eat(params[:user_id],params[:pos])
            Room.send_data(user_id,{eat_pos:params[:pos],items:map.get_items,user_id: params[:user_id]},params)
        else
            my_node.send({status: 1},params)
        end
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)
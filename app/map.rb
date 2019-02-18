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
        item = Room.pick_items(params[:user_id],params['pos'].to_i)
        item_list = Room.item_list(params[:user_id])
        Room.send_data(params[:user_id],{status:0,items:item_list,user_id: params[:user_id],pick_pos:params['pos'].to_i,id:item.get_id},params) 
    rescue Exception => e
        Log.re(e)
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('eat',-> params,my_node do
    begin
        if Room.eat(params[:user_id],params[:pos].to_i)
            item_list = Room.item_list(params[:user_id])
            Room.send_data(params[:user_id],{status:0,eat_pos:params[:pos].to_i,items:item_list,user_id: params[:user_id]},params)
        else
            my_node.send({status: 1},params)
        end
    rescue Exception => e
        Log.re(e)
        my_node.send({status: 1,error:e.message},params)
    end
end)
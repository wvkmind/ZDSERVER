Net::Connector.registerlogic('cp',-> params,my_node do
    begin
        Room.send_data(params[:user_id],params['cp_data'],params)
    rescue Exception => e
        Room.out(params[:user_id])
        my_node.send({status: 1,error:e.message},params)
    end
end)
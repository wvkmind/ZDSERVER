Net::Connector.registerlogic('ping',-> params,my_node do
    begin
        raise Exception.new('You are out.') unless my_node.flush_heartbeat(params[:user_id])
        my_node.send({status: 0},params) 
    rescue Exception => e
        my_node.send({error:e.message},params)
    end
end)
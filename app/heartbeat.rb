Net::Connector.registerlogic('ping',-> params,my_node do
    begin
        raise ServerException.new('You are out.') unless my_node.flush_heartbeat(params[:user_id],params[:ip],params[:port])
        my_node.send({status: 0},params) 
    rescue Exception => e
        Room.out_room(params[:user_id])
        raise e
    end
end)
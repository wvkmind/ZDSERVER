Net::Connector.registerlogic('get_package',-> params,my_node do
    begin
        my_node.send({status: 0,packages:User.get_user(params[:user_id]).get_packages_to_client},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)


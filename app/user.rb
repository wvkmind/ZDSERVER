Net::Connector.registerlogic('get_package',-> params,my_node do
    my_node.send({status: 0,packages:User.get_user(params[:user_id]).get_packages_to_client},params)
end)


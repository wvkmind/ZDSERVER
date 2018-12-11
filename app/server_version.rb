Net::Connector.registergate('version',-> r,node do
    begin
        node.send({status: 0,Key2:ServerConfig::VERSION},r)
    rescue Exception => e
        node.send({status: 1,error:e.message},node)
    end
end)


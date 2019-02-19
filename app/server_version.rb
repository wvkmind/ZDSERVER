Net::Connector.registergate('version',-> r,node do
    node.send({status: 0,Key2:ServerConfig::VERSION},r)
end)


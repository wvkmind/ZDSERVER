Net::Connector.registergate('version',-> r,node do
    node.send({Key2:ServerConfig::VERSION},r)
end)


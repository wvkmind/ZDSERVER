# -*- coding: utf-8 -*-
class NodeDispatchPort
    def gate
        @gate
    end
    def initialize
        @gate = Net::Connector.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT)
        @gate.register('in',-> r do
            @gate.send({Key2:"value222222"},r)
        end)
    end
end

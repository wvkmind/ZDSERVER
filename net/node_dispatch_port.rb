# -*- coding: utf-8 -*-
class NodeDispatchPort
    def gate
        @gate
    end
    def initialize
        @gate = Net::Connector.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT)
        @gate.register('in',-> r do
            puts r
        end)
    end
end

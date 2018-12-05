# -*- coding: utf-8 -*-
class NodeDispatchPort
    def gate
        @gate
    end
    def initialize
        @gate = Net::Connector.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT)
    end
end

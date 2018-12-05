# -*- coding: utf-8 -*-
class NodeDispatchPort
    def initialize
        @gate = Net::Connector.new(ServerConfig::NODE_TYPE[:logic],NetConfig::IP,NetConfig::PORT)
    end
end

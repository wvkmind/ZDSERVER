# -*- coding: utf-8 -*-
class NodeDispatchPort
    def initialize
        @gate = Net::Connector.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT)
    end
end

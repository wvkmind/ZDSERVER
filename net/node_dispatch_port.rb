# -*- coding: utf-8 -*-
class NodeDispatchPort
    def initialize
        @gate = Net::Connector.new(NetConfig::IP,NetConfig::PORT)
    end
end

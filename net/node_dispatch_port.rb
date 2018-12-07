# -*- coding: utf-8 -*-
require './net/node_dispatch_strategy'
class NodeDispatchPort < Net::Connector
    include NodeDispatchStrategy::NormalPatch
end

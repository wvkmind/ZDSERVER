module NodeDispatchStrategy
    module NormalPatch
        def nodes
            @nodes
        end
        def insert_available_node(user_id)
            available_node = nil
            @nodes = [] if @nodes.nil?
            @nodes.each do |node|
                available_node = node if node.node_users.include? user_id
            end
            
            @nodes.each do |node|
                if node.available(user_id)
                    available_node = node
                    break
                end
            end if (available_node==nil)

            available_node = create_node if(available_node==nil)

            available_node
        end
        def create_node
            if @nodes.length < NetConfig::PATCH_LIMIT
                node = Node.create(@nodes.length)
                @nodes << node
                node
            else
                nil
            end
        end
    end

    module MapPatch
        #[TODO]集群以后根据地图大小进行patch
    end
end 
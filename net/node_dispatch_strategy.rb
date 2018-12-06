module NodeDispatchStrategy
    module NormalPatch
        @nodes = []
        def insert_available_node(user_id)
            available_node = nil
            @nodes.each do |node|
                if node.available(user_id)
                    savailable_node = node
                    break
                end
            end
            if(available_node==nil)
                savailable_node = create_node
            end
            savailable_node
        end
        def create_node
            if @nodes.length < NetConfig::PATCH_LIMIT
                node = Node.create(@nodes.length)
                @nodes << Node.create(@nodes.length)
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
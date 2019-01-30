module NodeDispatchStrategy
    DataBase.add_remove("NodeNum")
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
            node_num = DataBase._redis_.get("NodeNum").to_i
            if node_num.nil? or node_num < NetConfig::PATCH_LIMIT
                node = Node.create(DataBase._redis_.incr("NodeNum"))
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
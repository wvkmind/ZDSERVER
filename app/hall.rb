Net::Connector.registerlogic('hall_list',-> params,my_node do
    begin
        rooms = Room.rooms.keys
        sum = rooms.length
        page = 0
        if params['page']!=nil 
            page = params['page'].to_i - 1
        end
        start_room = 0
        end_room = sum - 1
        if sum > DataConfig::HALL_PAGE_LIMIT
            start_room = DataConfig::HALL_PAGE_LIMIT*page
            end_room = start_room + DataConfig::HALL_PAGE_LIMIT - 1
            if start_room > sum
                start_room = sum - DataConfig::HALL_PAGE_LIMIT
                end_room = sum - 1
            end
        end
        ret = []
        (start_room..end_room).each do |i|
            ret << Room.rooms[rooms[i]].get_sample_info
        end
        my_node.send({status: 0,list: ret,page_sum: sum/DataConfig::HALL_PAGE_LIMIT+1,cur_page: start_room/DataConfig::HALL_PAGE_LIMIT+1},params) 
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('create_room',-> params,my_node do
    begin
        raise Exception.new ('Map name error.') unless params['map_name'].present?
        raise Exception.new ('Room name error.') unless params['room_name'].present?
        params['password'] = nil if params['password'] == '' or params['password'] == nil
        room_id = Room.create(params['password'],params['map_name'],params['room_name'],params[:user_id])
        my_node.send({status: 0,room_id:room_id},params) 
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('to_map',-> params,my_node do
    begin
        raise Exception.new ('Room id error.') unless params['room_id'].present?
        raise Exception.new ('Map name error.') unless params['map_name'].present?
        params['password'] = nil if params['password'] == '' or params['password'] == nil
        Room.join_map_or_room(params['room_id'],params['password'],params['map_name'],params[:user_id])
        my_node.send({status: 0,other_user: Room.get_other_info(params[:user_id])},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('flush_room',-> params,my_node do
    begin
        my_node.send({status: 0,other_user: Room.get_other_info(params[:user_id])},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('out_room',-> params,my_node do
    begin
        Room.out_room(params[:user_id])
        my_node.send({status: 0},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('in_labby',-> params,my_node do
    begin
        my_node.send({status: 0},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

Net::Connector.registerlogic('chat_labby',-> params,my_node do
    begin
        my_node.send({status: 0},params)
    rescue Exception => e
        my_node.send({status: 1,error:e.message},params)
    end
end)

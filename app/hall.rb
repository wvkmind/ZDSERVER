Net::Connector.registerlogic('hall_list',-> params,my_node do
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
end)

Net::Connector.registerlogic('create_room',-> params,my_node do
    raise ServerException.new ('Map name error.') unless params['map_name'].present?
    raise ServerException.new ('Room name error.') unless params['room_name'].present?
    params['password'] = nil if params['password'] == '' or params['password'] == nil
    room_id = Room.create(params['password'],params['map_name'],params['room_name'],params[:user_id])
    my_node.send({status: 0,room_id:room_id},params) 
end)

Net::Connector.registerlogic('to_map',-> params,my_node do
    raise ServerException.new ('Room id error.') unless params['room_id'].present?
    raise ServerException.new ('Map name error.') unless params['map_name'].present?
    params['password'] = nil if params['password'] == '' or params['password'] == nil
    map_id = Room.join_map_or_room(params['room_id'],params['password'],params['map_name'],params[:user_id])
    Room.send_data(params[:user_id],{new_one: User.get_user(params[:user_id]).to_client},{'name'=>'new_one'})
    my_node.send({
                    status: 0,
                    map_id: map_id,
                    other_user: Room.get_other_info(params[:user_id]),
                    talk_list: Room.talk_list(params[:user_id]),
                    item_list: Room.item_list(params[:user_id])
                },params)
end)

Net::Connector.registerlogic('flush_room',-> params,my_node do
    my_node.send({
        status: 0,
        other_user: Room.get_other_info(params[:user_id]),
        item_list: Room.item_list(params[:user_id])
    },params)
end)

Net::Connector.registerlogic('out_room',-> params,my_node do
    Room.out_room(params[:user_id])
    my_node.send({status: 0},params)
end)

Net::Connector.registerlogic('in_labby',-> params,my_node do
    my_node.send({status: 0},params)
end)

Net::Connector.registerlogic('chat_labby',-> params,my_node do
    my_node.send({status: 0},params)
end)

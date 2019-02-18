class Room
    
    @@rooms = {}
    DataBase.add_remove("Room")
    def self.create(password,map_name,room_name,creator_id)
        Room.out_room(creator_id)
        id = DataBase._redis_.incr("Room")
        @@rooms[id] = Room.new({
            id:id,
            password:password,
            map_name:map_name,
            room_name:room_name,
            creator_id:creator_id
        })
        id
    end

    def self.rooms
        @@rooms
    end

    def self.remove(id)
        @@rooms.delete(id)
    end

    def self.send_data(sender_user_id,data,params)
        user = User.get_user(sender_user_id)
        Map.maps[user.map_id].users.each do |map_user_id|
            map_user = User.get_user(map_user_id)
            unless map_user.ip_port.nil?
                params[:ip] = map_user.ip_port[:ip]
                params[:port] = map_user.ip_port[:port]
                map_user.node.send(data,params)
            end
        end if Map.maps[user.map_id]
    end

    def self.join_map_or_room(room_id,password,map_name,user_id)
        user = User.get_user(user_id)
        Map.exit_some(user_id,user.room_id!=room_id)
        user.set_room_id(room_id)
        @@rooms[room_id].join(password,user_id,map_name) 
    end

    def self.out_room(user_id)
        user = User.get_user(user_id)
        Room.send_data(user_id,{out_one:user.to_client},{'name'=>'out_one'}) if user
        user.set_room_id(nil) if user
        Map.exit_some(user_id)
    end

    def initialize(attribute)
        @password = attribute[:password]
        @map_name = attribute[:map_name]
        @room_name = attribute[:room_name]
        @creator_id = attribute[:creator_id]
        @id=attribute[:id]
        @maps = []
        @map_index = {}
        create_maps(@map_name)
        @maps[0].join(@creator_id)
        user = User.get_user(@creator_id)
        user.set_room_id(@id)
    end

    def select_map(map_name)
        @maps[@map_index[map_name]]
    end

    def create_maps(main_map)
        DataConfig::MAPDATA[main_map].each do |map|
            @map_index[map] = @maps.length
            @maps << Map.create(map,@id)
        end
        raise Exception.new('Create map error.') if @maps.length == 0
    end
 
    def join(password,user_id,map_name)
        raise Exception.new('Password error.') if @password && ( @password != password )
        raise Exception.new('The room is full.') if users_length >= DataConfig::ROOMUSERLIMIT
        DataBase._redis_.sadd("RoomUserList_#{@id}",user_id)
        if map_name.nil?
            @maps[0].join(user_id)
        else
            select_map(map_name).join(user_id)
        end
    end

    def get_sample_info
        ret = {}
        ret[:id]=@id
        ret[:thumb]=@maps[0].thumbnail
        ret[:map_name]=@map_name
        ret[:title]=@room_name
        ret[:user_number]="#{users_length}/#{DataConfig::ROOMUSERLIMIT}"
        ret[:user_list]=[]
        ret[:has_password] = !@password.nil? 
        DataBase._redis_.smembers("RoomUserList_#{@id}").each do |user_id|
            ret[:user_list] << User.get_user(user_id.to_i)[:type]
        end
        ret
    end

    def self.get_other_info(user_id)
        ret = []
        user = User.get_user(user_id)
        Map.maps[user.map_id].users.each do |map_user_id|
            ret << User.get_user(map_user_id).to_client if map_user_id!=user_id
        end
        ret
    end

    def users_length
        un = DataBase._redis_.scard("RoomUserList_#{@id}")
        un = 0 if un.nil?
        un
    end

    def same_one_out(user_id)
        DataBase._redis_.srem("RoomUserList_#{@id}",user_id)
        if(user_id==@creator_id)
            if users_length > 0
                @creator_id = DataBase._redis_.smembers("RoomUserList_#{@id}")[0].to_i
            else 
                @maps.each do |map|
                    Map.remove(map.id)
                end
                Room.remove(@id)
            end
        end
    end
    def self.get_map(user_id)
        user = User.get_user(user_id)
        map = Map.maps[user.map_id]
    end

    def self.pick_items(user_id,pos)
        user = User.get_user(user_id)
        map = Map.maps[user.map_id]
        item = map.pick_items(pos)
        raise "PickFalse" if item.nil?
        user.add_item(item) if item.is_garbage?
        item
    end

    def self.item_list(user_id)
        Room.get_map(user_id).get_items
    end

    def self.talk(user_id,message)
        Room.get_map(user_id).talk(message)
    end

    def self.talk_list(user_id)
        Room.get_map(user_id).talk_list
    end

    def self.eat(user_id,pos)
        user = User.get_user(user_id)
        map = Map.maps[user.map_id]
        map.eat(user,pos)
    end
    def self.cancel_eat(user_id,pos)
        user = User.get_user(user_id)
        map = Map.maps[user.map_id]
        map.cancel_eat(user,pos)
    end
end
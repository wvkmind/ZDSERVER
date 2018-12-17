class Map
    @@maps = {}
    @@map_user_map = {}
    DataBase.add_remove("Map")
    DataBase.add_remove("RoomUserList_*")
    def self.create(map_name,room_id)
        id = DataBase._redis_.incr("Map")
        @@maps[id] = Map.new({
            id:id,
            map_name:map_name,
            room_id:room_id
        })
        @@maps[id].maps
    end

    def self.remove(id)
        @@maps.delete(id)
    end

    def self.exit_some(user_id)
        @@maps[@@map_user_map[user_id]].out(user_id) unless @@map_user_map[user_id].nil?
    end

    def id
        @id
    end

    def self.maps
        @@maps
    end

    def initialize(attribute)
        @map_name = attribute[:map_name]
        @room_id = attribute[:room_id]
        @mutex=Mutex.new
        @users = {}
        create_maps
        @id=attribute[:id]
        @transfer_info = {}
    end

    def maps
        @maps
    end

    def create_maps
       @maps << self
    end

    #覆盖我，描写地图之间的传送门信息
    #比如 map1.set_transfer_info(map2.id,{x:80,y:80})
    #就是map1中有个传送门在80 90 位置，传到map2
    def set_transfer_info(map_id,info)
        @transfer_info[map_id] = info
    end

    def transfer_info
        @transfer_info
    end

    def can_pass
        return true
    end
 
    def join(user_id)
        @mutex.lock
        @users[user_id]=true
        @@map_user_map[user_id] = @id
        user = User.get_user(user_id)
        user.set_map_id(@id)
        DataBase._redis_.sadd("RoomUserList_#{@room_id}",user_id)
        @mutex.unlock
    end

    def thumbnail
        nil
    end

    def users
        @users
    end

    def out(user_id)
        @mutex.lock
        @users.delete(user_id)
        @@map_user_map.delete(user_id)
        user = User.get_user(user_id)
        user.set_map_id(nil)
        DataBase._redis_.srem("RoomUserList_#{@room_id}",user_id)
        Room.rooms[@room_id].same_one_out(user_id)
        @mutex.unlock
    end

    def locked?
        @mutex.locked?
    end
end
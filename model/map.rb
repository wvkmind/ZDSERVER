class Map
    @@maps = {}
    @@map_user_map = {}
    DataBase.add_remove("Map")
    DataBase.add_remove("RoomUserList_*")
    DataBase.add_remove("RoomUserList_*")
    def self.create(map_name,room_id)
        id = DataBase._redis_.incr("Map")
        @@maps[id] = Map.new({
            id:id,
            map_name:map_name,
            room_id:room_id
        })
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
        create_maps
        @id=attribute[:id]
    end
 
    def join(user_id)
        @mutex.lock
        @@map_user_map[user_id] = @id
        user = User.get_user(user_id)
        user.set_map_id(@id)
        DataBase._redis_.sadd("RoomUserList_#{@room_id}",user_id)
        DataBase._redis_.sadd("MapUserList_#{@id}",user_id)
        @mutex.unlock
    end

    def users
        DataBase._redis_.smembers("MapUserList_#{@id}").collect do |user_id|
            user_id.to_i
        end
    end

    def thumbnail
        nil
    end

    def out(user_id)
        @mutex.lock
        @@map_user_map.delete(user_id)
        user = User.get_user(user_id)
        user.set_map_id(nil)
        DataBase._redis_.srem("RoomUserList_#{@room_id}",user_id)
        DataBase._redis_.srem("MapUserList_#{@id}",user_id)
        Room.rooms[@room_id].same_one_out(user_id)
        @mutex.unlock
    end

    def locked?
        @mutex.locked?
    end
end
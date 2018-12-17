class Room
    
    @@rooms = {}
    DataBase.add_remove("Room")
    def self.create(type,password,map_name,room_name,creator_id)
        id = DataBase._redis_.incr("Room")
        @@rooms[id] = Room.new({
            id:id,
            type:type,
            password:password,
            map_name:map_name,
            room_name:room_name,
            creator_id:creator_id
        })
    end

    def self.rooms
        @@rooms
    end

    def self.remove(id)
        @@rooms.delete(id)
    end

    def initialize(attribute)
        @type = attribute[:type]
        @password = attribute[:password]
        @map_name = attribute[:map_name]
        @room_name = attribute[:room_name]
        @creator_id = attribute[:creator_id]
        @id=attribute[:id]
        create_maps
        @maps[0].join(@creator_id)
    end

    def create_maps
        @maps = Map.create(@map_name,@id)
        raise Exception.new('Create maps error.') if(@maps.nil?)
    end
 
    def join(password,user_id)
        raise Exception.new('Password error.') if( @password != password )
        raise Exception.new('The room is full.') if users_length >= DataConfig::ROOMUSERLIMIT
        @maps[0].join(user_id)
    end

    def get_sample_info
        ret = {}
        ret[:thumb]=@maps[0].thumbnail
        ret[:title]=@room_name
        
        ret[:user_number]="#{users_length}/#{DataConfig::ROOMUSERLIMIT}"
        ret[:user_list]=[]
        DataBase._redis_.smembers("RoomUserList_#{@id}").each do |user_id|
            ret[:user_list] << User.get_user(user_id.to_i)[:type]
        end
        ret
    end

    def users_length
        un = DataBase._redis_.scard("RoomUserList_#{@id}")
        un = 0 if un.nil?
        un
    end
    def same_one_out(user_id)
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
end
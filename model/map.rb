class Map
    @@maps = {}
    @@map_user_map = {}
    DataBase.add_remove("Map")
    DataBase.add_remove("MapUserList_*")
    DataBase.add_remove("MapItemPos_*")
    DataBase.add_remove("MapTalk_*")
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

    def self.exit_some(user_id,change=true)
        @@maps[@@map_user_map[user_id]].out(user_id,change) if  (@@map_user_map[user_id])!=nil && (@@maps[@@map_user_map[user_id]]!=nil)
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
        @items = []
        (0..9).each {|i|@items[i]=nil}
        Timer.register(30,->{self.flush_item})
        @id=attribute[:id]
        @MapItemPos = "MapItemPos_#{@id}"
        @MapUserList = "MapUserList_#{@id}"
        @MapTalk = "MapTalk_#{@id}"
        @id
    end

    def new_items(count)
        (1..count).each do
            item = Item.new(@items)
            @items[item.pos] = item
            DataBase._redis_.sadd(@MapItemPos,item.pos)
        end
    end

    def get_not_nil_items
        _items = []
        @items.each do |items|
            _items << _items unless items.nil?
        end
        _items
    end

    def get_items
        ret = []
        @items.each do |item|
            ret << item.to_client
        end
    end

    def pick_items(user,pos)
        if(DataBase._redis_.srem(@MapItemPos,pos).to_i==1)
            item = @items[pos]
            @items[pos] = nil
            send_change_item(user.id)
            return item
        else
            return nil
        end
    end

    def send_data(data,params)
        users.each do |map_user_id|
            map_user = User.get_user(map_user_id)
            params[:ip] = map_user.ip_port[:ip]
            params[:port] = map_user.ip_port[:port]
            map_user.node.send(data,params)
        end
    end

    def send_change_item(user_id)
        Job.add( -> do
            send_data({item_list:get_items},{'name'=>'change_item'})
        end)
    end

    def eat(user,pos)
        item = @items[pos]
        unless item.nil?
            if item.is_food? and item.energy!=0 and item.owner == nil
                item.eat
                user.eat(item.id)
                if item.energy == 0
                    @items[pos] = nil
                    send_change_item(user.id)
                end
                return true
            end
        end
        return false
    end

    def cancel_eat(user,pos)
        item = @items[pos]
        unless item.nil?
            if item.is_food?
                item.cancel_eat 
                user.cancel_eat
            end
        end
    end
    

    def flush_item
        if(get_not_nil_items.length<3)
            new_items(3-get_not_nil_items.length)
        end
        send_changeitem(user.id)
    end
    
 
    def join(user_id)
        @mutex.lock
        @@map_user_map[user_id] = @id
        user = User.get_user(user_id)
        user.set_map_id(@id)
        DataBase._redis_.sadd(@MapUserList,user_id)
        @mutex.unlock
        return @id
    end

    def users
        DataBase._redis_.smembers(@MapUserList).collect do |user_id|
            user_id.to_i
        end
    end

    def thumbnail
        nil
    end

    def out(user_id,change=true)
        @mutex.lock
        @@map_user_map.delete(user_id)
        user = User.get_user(user_id)
        user.set_map_id(nil)
        DataBase._redis_.srem(@MapUserList,user_id)
        if change
            Room.rooms[@room_id].same_one_out(user_id)
        end
        @mutex.unlock
    end

    def locked?
        @mutex.locked?
    end

    def talk(message)
        DataBase._redis_.zadd(@MapTalk,Time.now.to_f.to_s,message)
        count = DataBase._redis_.zcard(@MapTalk).to_i
        DataBase._redis_.zremrangebyrank(@MapTalk,0,-20) if 20 < count
    end
    def talk_list
        list = DataBase._redis_.zrange(@MapTalk,-20,-1)
    end
end
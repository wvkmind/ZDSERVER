class User < ActiveRecord::Base
	self.table_name = "users"
	self.primary_key = "id"
	self.inheritance_column = '_type'
	@@user_mem = {}
	def to_h
		{
			status: 0,
			id: self[:id],
			account: self[:account]
		}
	end
	def to_client
		{
			status:0,
			id: id,
			account: account,
			name:name,
			type:type,
			tra_rate:tra_rate,
			phy_str_rate:phy_str_rate,
			exp_rate:exp_rate,
			level:level,
			zhanyang:zhanyang,
			buliang:buliang,
			room_pos:room_pos
		}
	end
	def self.user_mem
		@@user_mem
	end
	def self.login(user)
		Room.out_room(user[:id]);
        @@user_mem[user[:id]] = user
    end
	def self.loginout(id)
		Room.out_room(id);
        @@user_mem.delete(id)
    end
    def self.get_user(id)
        @@user_mem[id]
	end
	
	def set_map_id(id)
		@map_id = id
	end

	def map_id
		@map_id
	end

	def set_room_id(id)
		@room_id = id
	end

	def room_id
		@room_id
	end

	def set_ip_port(data)
		@ip_port = data
	end

	def ip_port
		@ip_port
	end

	def set_node(data)
		@node = data
	end

	def node
		@node
	end

	def room_pos
		@room_pos || [0,0,0,0,0]
	end

	def set_room_pos(pos)
		@room_pos = pos
	end

end
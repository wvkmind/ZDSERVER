class User < ActiveRecord::Base
	self.table_name = "users"
	self.primary_key = "id"
	self.inheritance_column = '_type'

	has_many :packages

	@@user_mem = {}
	def to_h
		{
			status: 0,
			id: id,
			account: account
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
			tilizhi: tilizhi,
			buliang:buliang,
			food_id: @food_id,
			exp: exp,
			room_pos:room_pos
		}
	end
	def self.user_mem
		@@user_mem
	end
	def self.login(user)
		loginoutsave(user)
		Room.out_room(user[:id])
        @@user_mem[user[:id]] = user
    end
	def self.loginout(id)
		loginoutsave(@@user_mem[id])
		Room.out_room(id)
        @@user_mem.delete(id)
	end
	def self.loginoutsave(user)
		user.save unless user.nil?
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

	def add_item(item)
		User.transaction do
			have_item = packages.where(type: item.type,item_id: item.get_id).take
			if have_item.nil?
				packages << Package.create({
					type: item.type,
					item_id: item.get_id,
					count: 1
				})
				self.save
			else
				have_item.count = have_item.count + 1
				have_item.save
			end
		end
	end

	def remove_item(item)
		User.transaction do
			have_item = packages.where(type: item.type,item_id: item.get_id).take
			if have_item.nil?
				return -1
			else
				have_item.count = have_item.count - 1
				if have_item.count > 0
					return have_item.count
					have_item.save
				else
					have_item.destroy
					return 0
				end
			end
		end
	end

	def get_packages_to_client
		ret = []
		packages.each do |item|
			ret << {
				type: item.type,
				id: item.item_id,
				count: item.count
			}
		end
		ret
	end

	def eat(id)
		step = 0.001*(self.exp_rate+1)*DataConfig::LEVEL_EXP[self.level]
		add_exp(step)

		step = 0.001*(self.phy_str_rate*id+1)*100
		step = 1 if(step<1)
		add_tilizhi(step)
		@food_id = id
	end

	def cancel_eat
		@food_id = nil
	end

	def add_tilizhi(new_tilizhi)
		new_tilizhi = 100 if new_tilizhi > 100
		if new_tilizhi > self.tilizhi
			self.tilizhi = new_tilizhi
		end
		self.save
	end

	def pick_exp
		step = 0.001*(self.exp_rate+1)*DataConfig::LEVEL_EXP[self.level]
		add_exp(step)
	end

	def add_exp(step)
		step = 1 if step < 1
		self.exp = self.exp + step 
		@node.send({status: 0,exp:self.exp},{'name'=>'ce'}.merge(ip_port)) 
		new_level = level
		(DataConfig::LEVEL_EXP[level]..DataConfig::LEVEL_EXP.length-1).each_with_index do |limit,i|
			new_level = i  if self.exp >= limit
		end
		if new_level > level
			self.level = new_level
			Job.add( -> do
				Room.send_data(self.id,{id:self.id,leve_up:self.level},{'name'=>'plu'})
			end)
		end
		self.save
	end

end
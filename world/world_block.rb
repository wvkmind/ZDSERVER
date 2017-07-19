#服务器用模块儿
#目的是区分元素所在位置，其中x_id y_id为，以固定@world_w宽的方块儿在世界的坐标
#code by wvkmind
module WorldBlock
	#private
	#生命期
	#1出生
	#x y => block_id
	def which_block(data)
		data[:quadrant] = nil
		x = data[:x]
		y = data[:y]
		x>0 ? y>0 ? data[:quadrant] = :o : data[:quadrant] = :f : y>0 ? data[:quadrant] = :t : data[:quadrant] = :th
		data[:x_id] = x/@world_w
		data[:y_id] = y/@world_w
		data
	end
	def im_here(data)
		x = data[:x]
		y = data[:y]
		#a block id 	
		cur_dil  = {}
		cur_dil  = which_block(cur_dil)
		quadrant = cur_dil[:quadrant]
		x_id     = cur_dil[:x_id]
		y_id     = cur_dil[:y_id]
		#insert data to block array with block_id
		@world_block[quadrant][x_id]	           	   = {} if @world_block[quadrant][x_id].nil?
		@world_block[quadrant][x_id][y_id]      	   = {} if @world_block[quadrant][x_id][y_id].ni?
		@world_block[quadrant][x_id][y_id][data[:uid]] = data
		data[:x_id]     = x_id
		data[:y_id]     = y_id
		data[:quadrant] = quadrant
	end
	#2成长
	def fix_x_y(data,new_x,new_y)
		delete(data)
		im_here(data,new_x,new_y)
	end
	#3死亡 有的地方说 死亡即前往另一个世界
	def delete(data)
		@world_block[data[:quadrant]][data[:x_id]][data[:y_id]].delete(data[:uid]) if data[:x_id]
	end	
	
	#public:
	def init
		@world_block	  = {}
		@world_block[:o]  = {}#第一象限
		@world_block[:t]  = {}#第二象限
		@world_block[:th] = {}#第三象
		@world_block[:f]  = {}#第四象限
		@world_w          = 500#瞎j8弄得数	
	end
	
	def reload_element
		#TODO: 崩溃及服务转移数据的来源
		#TODO: 本地映射处理
		#TODO: 进行映射
	end
	

	def new_one(data)
		im_here(data)
	end
	

	#主要控制生命期内块儿id的取值
	def update_one(data,new_x,new_y)
		fix_x_y(data,new_x,new_y)
	end


	#这是最主要所体现的内容，以数据源为圆心所波及到的最多四个block的数据
	def get_one_neighbor_and_self_block_id(data)
		x = data[:x]
		y = data[:y]
		#get this one block_id as we know
		this_one_block_id       = {x_id: data[:x_id],y_id: data[:y_id]} 
		this_one_block_quadrant = data[:quadrant]
		#split right left  up down
		x_in_block = x % @world_w
		
		y_in_block = y %  @world_w
		
		half_w = @world_w / 2

		

		x_q = [this_one_block_id[:x_id]]
		y_q = [this_one_block_id[:y_id]]

		x_q.push this_one_block_id[:x_id] - 1 if (x_in_block < half_w)
		
		x_q.push this_one_block_id[:x_id] + 1 if (x_in_block > half_w)

		y_q.push this_one_block_id[:y_id] - 1 if (y_in_block < half_w)

		y_q.push this_one_block_id[:y_id] + 1 if (y_in_block > half_w)

		return_block_info = []
		x_q.each do |x|
			y_q.each do |y|
				return_block_info.push({x_id: x,y_id: y})
			end	
		end

		return_block_info
	end

	#TODO: 资源回收，硬删除处理
end

#state_machine
module StateMachine
	
	def init_machine
		@state_pool = {}
		@cur_sate_name = :nothing
		p 'init_machine'
	end

	def add_state(info)#begin,end,name,allow_from_names
		@state_pool[info[:name ]] = info
	end

	def change_state(name)
		if @cur_sate_name == name and @cur_sate_name != :nothing
			return false
		end
		if @state_pool.has_key?name
			if @cur_sate_name == :nothing 
				@state_pool[name][:begin].call(:nothing)
				@cur_sate_name = name
				return true
			else
				unless @state_pool[name][:allow_from_names].nil?
					@state_pool[name][:allow_from_names].each do |v|
						if v == @cur_sate_name
							@state_pool[v][:end].call(name)
							@state_pool[name][:begin].call(v)
							@cur_sate_name = name
							return true
						end				
					end
				else
					@state_pool[v][:end].call(name)
					@state_pool[name][:begin].call(v)
					@cur_sate_name = name
					return true
				end
			end
			return false
		else
			return false
		end
	end

end
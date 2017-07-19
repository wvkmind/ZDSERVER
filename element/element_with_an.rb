require './machine/state_machine.rb'
require './element/element'
require './timer/timer'
class EWA < Element
	
	include StateMachine
	
	def initialize
		init_machine
		init_addtr
	end

	def add_action(action_name,file_paths,mm,times,allow_from_names)
		info           = {}
		info[:name]    = action_name 
		file_paths.each do |v|
			Texture.need_textrue(v)
		end
		i = 0
		n = file_paths.length
		info[:proc] = Proc.new do 
			update_textrue(file_paths[i])
			i = i + 1
			i = 0 if i==n 
		end
		begin_function = Proc.new do |pre_action_name |
			Timer.register(mm,info[:proc],times)
		end
		end_function   = Proc.new do |next_action_name|
			Timer.unregister(mm,info[:proc]) if(times!=:forevery and times!=-1)
		end
		info[:begin] = begin_function
		info[:end] = end_function
		info[:allow_from_names] = allow_from_names
		add_state(info)
	end

end

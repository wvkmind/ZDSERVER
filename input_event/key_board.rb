#key_board event 
#
require 'singleton'

module KeyBoard
	class Event
		include Singleton
		def initialize
			@event_pool = {}
			super
		end

		def register(status,key,proc)
			@event_pool[status] = {} if @event_pool[status].nil?
			@event_pool[status][key] = {} if @event_pool[status][key].nil?
			@event_pool[status][key][proc] = true 
		end

		def cancel(status,key,proc)
			@event_pool[status][key].delete proc if ! @event_pool[status].nil? && ! @event_pool[status][key].nil?
		end

		def key_down_register(key,proc) 
			register(:down,key,proc)
		end

		def key_down_cancel(key,proc)
			cancel(:down,key,proc)
		end

		def key_up_register(key,proc) 
			register(:up,key,proc)
		end

		def key_up_cancel(key,proc) 
			cancel(:up,key,proc)
		end

		def key_register(key,in_proc,out_proc)
			@event_pool[:key] = {} if @event_pool[:key].nil?
			@event_pool[:key][key] = {} if @event_pool[:key][key].nil?
			@event_pool[:key][key][in_proc] = out_proc
		end

		def key_cancel(key,in_proc) 
			@event_pool[:key][key].delete in_proc if ! @event_pool[:key].nil? && ! @event_pool[:key][key].nil?
		end

		def do_up_key(key,x,y)
			if !@event_pool[:up].nil? and !@event_pool[:up][key].nil?
				@event_pool[:up][key].each do |proc,flag|
					proc.call(x,y)
				end
			end
			if !@event_pool[:key].nil? and !@event_pool[:key][key].nil?
				@event_pool[:key][key].each do |in_proc,out_proc|
					in_proc.call(x,y)
				end
			end
		end

		def do_down_key(key,x,y)
			if !@event_pool[:down].nil? and !@event_pool[:down][key].nil?
				@event_pool[:down][key].each do |proc,flag|
					proc.call(x,y)
				end
			end
			if !@event_pool[:key].nil? and !@event_pool[:key][key].nil?
				@event_pool[:key][key].each do |in_proc,out_proc|
					out_proc.call(x,y)
				end
			end
		end

	end
end
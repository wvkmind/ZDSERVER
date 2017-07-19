#key_board event 
#
require 'singleton'
require './global/global_variables'
#status 
#GLUT_DOWN,GLUT_UP
#button 
#GLUT_LEFT_BUTTON,GLUT_MIDDLE_BUTTON,GLUT_RIGHT_BUTTON,GLUT_WHEEL_UP,GLUT_WHEEL_DOWN

module Mouse
	class Event
		include Singleton
		def initialize
			@event_pool = {}
			@move_pool={}
			@entry_pool={}
			super
		end

		def register_up_down(status,key,proc)
			@event_pool[status] = {} if @event_pool[status].nil?
			@event_pool[status][key] = {} if @event_pool[status][key].nil?
			@event_pool[status][key][proc] = true 
		end

		def cancel_up_down(status,key,proc)
			@event_pool[status][key].delete proc if ! @event_pool[status].nil? && ! @event_pool[status][key].nil?
		end

		def register_move(status,proc)
			#:down :up 
			@move_pool[status] = {} if @move_pool[status].nil?
			@move_pool[status][proc] = true 
		end

		def cancel_move(status,proc)
			@move_pool[status].delete proc if ! @move_pool[status].nil? 
		end

		def register_entry(status,proc)
			#GLUT_LEFT=0
			#GLUT_ENTERED=1
			@entry_pool[status] = {} if @entry_pool[status].nil?
			@entry_pool[status][proc] = true 
		end

		def cancel_entry(status,proc)
			@entry_pool[status].delete proc if ! @entry_pool[status].nil? 
		end

		def do_up_down(button,state,x,y)
			if !@event_pool[state].nil? and !@event_pool[state][button].nil?
				@event_pool[state][button].each do |proc,flag|
					proc.call(x,y)
				end
			end
		end

  		def mouseDownMove(x,y)
  			if !@move_pool[:up].nil?
	  		  	@move_pool[:up].each do |proc,flag|
	  		  		proc.call(x,y)
	  		  	end
	  		end
  		end

  		def mouseMove(x,y)
			if !@move_pool[:down].nil?
	  		  	@move_pool[:down].each do |proc,flag|
	  		  		proc.call(x,y)
	  		  	end
	  		end
  		end

  		def mouseEntry(state)
			if !@entry_pool[state].nil?
	  		  	@entry_pool[state].each do |proc,flag|
	  		  		proc.call
	  		  	end
	  		end
  		end

		
	end
end


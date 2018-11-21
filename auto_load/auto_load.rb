#auto load *.rb except test 
#
require 'singleton'

module AutoLoad
	class G
		include Singleton
		def init
			Log.info "auto reload init."
			@file_last_update_time = {}
			@need_reload_file = {}
			@filter_file = {}
			Thread.new do
				begin 
					while true do
						@need_reload_file = {}
						update_dir './need_reload'
						up_queue = @need_reload_file.sort 
						up_queue.each do |e|
							begin 
								load e[0]
								Log.info "reload #{e[0]}"
							rescue Exception => error
								@filter_file[e[0]] = true
								Log.re error
							end
						end
						sleep 1
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
				end
			end
		end
		def update_dir path
			Dir.entries(path).each do |e| 
				if e[0] !='.' and 
					e = path+ '/' + e
					if File::ftype(e)=='directory' 
						update_dir e
					elsif (File::ftype(e)=='file') and (e[(e.length-3)..(e.length-1)]=='.rb') 
						time = File::mtime(e).to_i
						pre_time = @file_last_update_time[e] 
						if not @filter_file[e] or (@filter_file[e] and time - pre_time > 60)
							@filter_file[e]=false
							if (pre_time == nil or pre_time < time) 
								@file_last_update_time[e] = time
								@need_reload_file[e] = time 
							end
						end
					end
				end
			end
		end
	end
end

#AutoLoad::G.instance.init
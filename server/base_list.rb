
def update_dir path,need_reload_file
		Dir.entries(path).each do |e| 
				if e[0] !='.' and 
						e = path+ '/' + e
						if File::ftype(e)=='directory' 
								update_dir e,need_reload_file
						elsif (File::ftype(e)=='file') and (e[(e.length-3)..(e.length-1)]=='.rb') 
								need_reload_file[e] = true 
						end
				end
		end
end
def init(path)
		need_reload_file = {}
		update_dir path,need_reload_file
		up_queue = need_reload_file.sort 
		up_queue.each do |e|
			require e[0] 
		end
end
init('./database')
init('./net')
init('./app')

begin 
	Net::bind('127.0.0.1',6655)
	start = Thread.new do
  		loop do
    		sleep(6*10000)
  		end
	end
rescue Exception => e
	puts e.message
	puts e.backtrace
	retry
end
start.join
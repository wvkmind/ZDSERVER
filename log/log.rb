require 'logger'
module Log
	@@infos = Queue.new
	def self.info(info)
		@@infos << info
  end
  def self.re(info)
  	if info.class == 'String'
  		info(info)
  	else
    	@@infos << info.message
    	info.backtrace.each do |variable|
    		@@infos << variable 
    	end
    end
	end
	def self.write
		@@thread = Thread.new do 
			loop do 
				info = @@infos.pop
				Logger.new('./log/all.log').info info
			end
		end
	end

	def self.end
		unless  @@thread.nil?
			Thread.kill @@thread
		end
	end

end
#for game world synchroize infomation , client to server  and sever to client
#FIFO
#wvkmind 
require 'singleton' 
require './log/log'
module NetBuffer
	def self.push(u)
		NetBuffer::Buffer.instance.push_udp_information_to_queue_end u
	end
	def self.get_sync
		NetBuffer::Buffer.instance.pop_sync
	end
	def self.get_need_wait
		NetBuffer::Buffer.instance.pop_need_wait
	end
	class Buffer
		include Singleton


		def initialize
			@udp_package_sync_queue = Queue.new

			@udp_package_wait_queue = Queue.new

			@udp_send_queue = Queue.new

			super
		end
		
		def push_udp_send_info_to_queue_end(send)
			@udp_send_queue << send
		end

		def push_udp_information_to_queue_end(udp_package_)
			udp_package = eval udp_package_[0].to_s
			udp_package[:from_info] = {:ip => udp_package_[1][2],:port  => udp_package_[1][1]}
			if udp_package[:type] == :sync
				@udp_package_sync_queue << udp_package
			else
				@udp_package_wait_queue << udp_package
			end
		end
		def pop_sync
			@udp_package_sync_queue.pop
		end
		def pop_need_wait
			@udp_package_wait_queue.pop
		end
		def pop_send
			@udp_send_queue.pop
		end
	end
end

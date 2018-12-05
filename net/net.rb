
require 'socket'
module Net
	class Connector
		
		@@node_set = {}
		
		def self.insert_node(node)
			if(@@node_set.has_key?(node.node_type))
				@@node_set[node.node_type] << node
			else
				@@node_set[node.node_type] = [node]
			end
		end

		def self.get_nodes_with_type(node_type)
			@@node_set[node_type]
		end

		def initialize(node_type,ip_string,port_number)
			@socket = UDPSocket.new
			@socket.bind(ip_string, port_number)
			@recive_queue = Queue.new
			@send_queue = Queue.new
			@recive_thread = nil
			@send_thread = nil
			@node_type = node_type
			@events = {}
			
			restart_recive_thread
			restart_send_thread
		end

		def register(event_name,backcall)

		end

		def unregister(event_name)

		end

		def send(info,ip,port)
			@send_thread << {info: info,ip: ip,port: port}
		end


		def restart_recive_thread
			Thread.kill(@recive_thread) unless @recive_thread == nil
			@recive_thread = Thread.new do
				begin 
					loop do
						tmp_ = @socket.recvfrom(NetConfig::MTU)
						@recive_queue << tmp_
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
					retry
				end
			end
		end

		def restart_send_thread
			Thread.kill(@send_thread) unless @send_thread == nil
			@send_thread = Thread.new do
				begin 
					loop do
						send_info = @send_queue.pop
						@udp_socket.send(send_info[:info], 0, send_info[:ip], send_info[:port])
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
					retry
				end
			end
		end

		def stop_all_thread
			Thread.kill(@recive_thread) unless @recive_thread == nil 
			@recive_thread = nil
			Thread.kill(@send_thread) unless @send_thread == nil 
			@send_thread = nil
		end

	end
end

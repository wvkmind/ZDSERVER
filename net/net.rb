require 'socket'
module Net
	class Connector
		
		@@node_set = {}
		@@events = {}

		ServerConfig::NODE_TYPE.each do |key,value|
			Net::Connector.define_singleton_method("register#{key.to_s}") do |event_name,backcall|
				Net::Connector.register(value,event_name,backcall)
			end
			Net::Connector.define_singleton_method("unregister#{key.to_s}") do |event_name|
				Net::Connector.unregister(value,event_name)
			end
		end	

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
		def port
			@port
		end
		def ip
			@ip
		end
		def node_type
			@node_type
		end
		def initialize(node_type,ip_string,port_number)
			@socket = UDPSocket.new
			@socket.bind(ip_string, port_number)
			@ip = ip_string
			if(port_number == 0 )
				@port = @socket.local_address.ip_port
			else
				@port = port_number
			end
			@recive_queue = Queue.new
			@send_queue = Queue.new
			@recive_thread = nil
			@send_thread = nil
			@event_thread = nil
			@node_type = node_type
			Net::Connector.insert_node(self)
			restart_recive_thread
			restart_send_thread
			restart_event_thread
		end

		def self.register(node_type,event_name,backcall)
			@@events[node_type] = {} if @@events[node_type].nil?
			@@events[node_type][event_name] = [] if @@events[node_type][event_name].nil?
			@@events[node_type][event_name] << backcall
		end

		def self.unregister(node_type,event_name)
			@@events[node_type][event_name] = nil unless @@events[node_type].nil?
		end

		def fire(data)
			@@events[@node_type][data['name']].each do |p|
				p.call(data,self)
			end
		end

		def send(info,r)
		    info = info.merge({event_name: r['name']})
			@send_queue << {info: Packer.pack(info),ip: r[:ip],port: r[:port]}
		end

		def restart_event_thread
			Thread.kill(@event_thread) unless @event_thread == nil
			@event_thread = Thread.new do
				begin 
					loop do
						source = @recive_queue.pop
						fire(source)
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
					retry
				end
			end
		end

		def check_token(token)
            if token.nil?
                return nil
            end
			token = Base64.decode64 token
			account, id = token.split(':')
			session = Session.get_session(account)
            if session.nil? || session[:token] != id
                nil
            else
                return session[:user_id]
            end
		end

		def restart_recive_thread
			Thread.kill(@recive_thread) unless @recive_thread == nil
			@recive_thread = Thread.new do
				begin 
					loop do
						tmp_ = @socket.recvfrom(NetConfig::MTU)
						data = Packer.unpack(tmp_[0])
						data[:ip] = tmp_[1][2]
						data[:port] = tmp_[1][1]
						if @node_type == ServerConfig::NODE_TYPE[:logic]
							data[:user_id] = check_token(data['token'])
							if data[:user_id] != nil
								@recive_queue << data
							else
								send({status: 1,error:'notoken'},data)
							end
						else
							@recive_queue << data
						end	
						
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
						@socket.send(send_info[:info], 0, send_info[:ip], send_info[:port])
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
			Thread.kill(@event_thread) unless @event_thread == nil 
			@event_thread = nil
		end

	end
end

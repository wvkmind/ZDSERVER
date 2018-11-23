#low floor net work 
#sever and client use it 
#wvkmind
require 'socket'
require 'singleton'
require './net/net_buffer'
require './log/log'
udp_recv_thread_init = false
module Net
	
	#client use 
	#1.Net::connect_sever
	#2.EventManage::register_event
	#3.Net::send_event_msg or Net::send_sync_msg
	#send info need have {:name=>XXXXX,:info=>YYYYY}

	#server use 
	#1.Net::bind
	#2.EventManage::register_event
	#3.Net::send_normal_event_with_recv or Net::send_sync_with_recv
	#send info need have {:name=>XXXXX,:info=>YYYYY},from_info

	def self.connect_sever(ip,port)
		Net::Connector.instance.set_to_ip_port(ip,port)
		Net::Connector.instance.start_udp_recv_thread
	end
	def self.send_event_msg(a)
		Net::Connector.instance.send_msg_({:name=>a[:name],:type=>:normal,:info=>a[:info]})
	end

	def self.send_sync_msg(a)
		Net::Connector.instance.send_msg_({:name=>a[:name],:type=>:sync,:info=>a[:info]})
	end
	###############################################################################################
	def self.bind(ip,port)
		Net::Connector.instance.bind_with_ip_port(ip,port)
	end

	def self.send_normal_event_with_recv(a,r)
		Net::send_with_recv({:name=>a[:name],:type=>:normal,:info=>a[:info]},r)
	end

	def self.send_sync_with_recv(a,r)
		Net::send_with_recv({:name=>a[:name],:type=>:sync,:info=>a[:info]},r)
	end

	def self.send_with_ip_port(a,ip,port)
		Net::Connector.instance.send_with_ip_port_(a,ip,port)
	end

	################################################################################################

	def self.send_with_recv(a,r)
		Net::Connector.instance.send_with_ip_port_(a,r[:from_info][:ip],r[:from_info][:port])
	end	

	class Connector
		include Singleton
		public

		def initialize
      		@udp_socket         = UDPSocket.new
      		@udp_socket_to_ip   = nil
      		@udp_socket_to_port = nil
			@udp_recv_thread    = nil
      		supe4r
		end

		def bind_with_ip_port(ip_string,port_number)
			stop_udp_recv_thread
			@udp_socket.close
			@udp_socket = UDPSocket.new
			@udp_socket.bind(ip_string, port_number)
			start_udp_recv_thread
			start_udp_send_thread
		end

		def set_to_ip_port(ip_string,port_number)
			@udp_socket_to_ip   = ip_string
			@udp_socket_to_port = port_number
		end

		def send_msg_(a)
			unless @udp_socket_to_ip == nil
				NetBuffer::push_udp_send_info_to_queue_end({
					info:a.to_s,
					ip:@udp_socket_to_ip,
					port:@udp_socket_to_port
				})
			end
		end
		def send_with_ip_port_(a,ip,port)
			NetBuffer::push_udp_send_info_to_queue_end({
				info:a.to_s,
				ip:ip,
				port:port
			})
		end

		def send()
			send_info = NetBuffer::pop_send
			@udp_socket.send(send_info[:info], 0, send_info[:ip] , send_info[:port])
		end
		def start_udp_recv_thread
			Thread.kill(@udp_recv_thread) unless @udp_recv_thread == nil
			@udp_recv_thread = Thread.new do
				begin 
					loop do
						tmp_ = @udp_socket.recvfrom(1024)
						NetBuffer::push tmp_
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
					retry  
				end
			end
		end

		def stop_udp_recv_thread
			Thread.kill(@udp_recv_thread) unless @udp_recv_thread == nil 
			@udp_recv_thread = nil
		end
		def start_udp_send_thread
			Thread.new do
				send()
			end
		end
	end
end

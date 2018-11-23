#for deal with recv net msg 
#wvkmind
require './net/net'
require './net/net_buffer'
require 'singleton' 
require './log/log'
module EventManage
	
	#注册 
	def self.register_event(proc,event)
		if event.class != Hash
			event = {
				name: event,
				type: :normal
			}
		end
		EventManage::Manage.instance.register_event proc,event
	end
	#移除
	def self.remove_event(proc,event)
		EventManage::Manage.instance.remove proc,event
	end
	class Manage
		include Singleton
		def initialize
			@synchronization_status_event = Hash.new
			@need_wait_and_normal_event   = Hash.new
			@synchronization_loop_thread = Thread.new do
				sync_loop
			end
			@need_wait_and_normal_loop_thread = Thread.new do
				normal_loop
			end
			super
		end

		def register_event(proc,event)
			if event[:type] == :sync
				@synchronization_status_event[event[:name]]       = Hash.new if @synchronization_status_event[event[:name]] == nil
				@synchronization_status_event[event[:name]][proc] = true  
			else
				@need_wait_and_normal_event[event[:name]]       = Hash.new if @need_wait_and_normal_event[event[:name]] == nil
				@need_wait_and_normal_event[event[:name]][proc] = true
			end
		end

		#同步的东西要保证按照接收的时间来处理
		def sync_loop
			begin 
				loop do 
					cur_sync = NetBuffer::get_sync
					if @synchronization_status_event[cur_sync[:name]]!=nil
						@synchronization_status_event[cur_sync[:name]].each do |q,flag|
							q.call cur_sync
						end
					end
				end
			rescue Exception => e
				Log.info e.massage
				Log.info e.backtrace
				retry
			end
		end

		#正常的信息处理的时候直接放到线程池
		def normal_loop
			begin
				loop do 
					cur_sync = NetBuffer::get_need_wait
					if @need_wait_and_normal_event[cur_sync[:name]] != nil
						@need_wait_and_normal_event[cur_sync[:name]].each do |q,flag|
							#[TODO]线程池
							Thread.new do
								q.call cur_sync
							end
						end
					end
				end
			rescue Exception => e
				Log.info e.massage
				Log.info e.backtrace
				retry
			end
		end

		def remove(proc,event)
			if event[:type] == :sync
				@synchronization_status_event[event[:name]].delete proc unless @synchronization_status_event[event[:name]] == nil
				if @synchronization_status_event[event[:name]].length == 0 
					@synchronization_status_event.delete  event[:name]
				end
			else
				@need_wait_and_normal_event[event[:name]].delete proc unless @need_wait_and_normal_event[event[:name]] == nil
				if @need_wait_and_normal_event[event[:name]].length == 0 
					@need_wait_and_normal_event.delete  event[:name]
				end
			end
		end

	end
end
#timer
#wvkmind

require 'singleton'
require 'date'
require './log/log'
module Timer
	def self.register(mm,proc,times=:forevery) 
		Timer::TimerManagement.instance.insert(mm,proc,times) 
	end
	def self.unregister(mm,proc) 

		Timer::TimerManagement.instance.remove(mm,proc) 
	end
	class TimerManagement
		include Singleton
		def thread
			@tread = Thread.new do
				cao = Time.now.to_f
				begin 
					while(1)do 
						sleep(0)
						caoni = Time.now.to_f
						caonima = caoni - cao
						if caonima.to_f < 0.001

						else
							time_proc = Proc.new do
								while(@function_pool_m.length!=0)do
									function_pool_m_f
								end
								@function_pool.each do |mmkey,mmvalue|
									if mmvalue == false
										@function_pool.delete mmkey
									else
										mmvalue.each do |proc,timerinfo|
											begin
												if timerinfo[:times] == 0 
													raise 'one timer proc normal quit.'
												else
													if @function_pool[mmkey][proc][:curtime] >= mmkey
														@function_pool[mmkey][proc][:curtime] = @function_pool[mmkey][proc][:curtime] - mmkey
														proc.call
														if timerinfo[:times] == :forevery or timerinfo[:times] == -1
															
														else
															@function_pool[mmkey][proc][:times] = timerinfo[:times] - 1
														end
													else
														@function_pool[mmkey][proc][:curtime] = @function_pool[mmkey][proc][:curtime] + 0.001
														
													end
												end
											rescue Exception => e  
												@function_pool_m.push({:mm=>mmkey,:proc=>proc,:flag=>:del})
												@function_pool[mmkey] = false if @function_pool[mmkey].length == 0
												Log.re e
											end	
										end
									end
								end
							end
							(caonima/0.001).to_i.times do 
								time_proc.call
							end
							cao = caoni -caonima%0.001
						end
					end
				rescue Exception => e  
					Log.info e.message	
					Log.info e.backtrace
					retry  
				end
			end
		end
		def initialize 
			@function_pool = {}
			@function_pool_delete = {}
			@function_pool_m = Queue.new
			thread
			super
		end
		def insert(mm,proc,times)
			@function_pool_m.push({:mm=>mm,:proc=>proc,:times=>times,:flag=>:add})
		end
		def function_pool_m_f
			i = @function_pool_m.pop()
			mm = i[:mm]
			proc = i[:proc]
			if i[:flag] == :add
				times = i[:times]
				@function_pool[mm] = {} if (not @function_pool.has_key?mm)
				@function_pool[mm][proc] = {:live=>true,:times=>times,:curtime=>0.0}
			else
				begin
				@function_pool[mm].delete proc
				rescue Exception => e  
					Log.re e
				end
			end
		end
		def remove(mm,proc)
			return if (not @function_pool.has_key?mm)
			return if (not @function_pool[mm].has_key?proc)
			@function_pool_m.push({:mm=>mm,:proc=>proc,:flag=>:del})
		end
	end
end
require './net/net'
require './net/net_msg_transmit'
i = 1
begin 
	Net::bind('127.0.0.1',6655)
	start = Thread.new do

  		EventManage::register_event(Proc.new do |r|
				i = i + 1
        Net::send_with_recv("recive#{i}\0",r)
      end,{
        :name=>:V,:type=>:normal
      })

  		loop do
    		sleep(0)
  		end

	end
rescue Exception => e
	puts e.message
	puts e.backtrace
	retry
end
start.join
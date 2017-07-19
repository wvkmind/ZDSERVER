require './net/net'
require './net/net_msg_transmit'

begin 
	Net::bind('127.0.0.1',6655)
	start = Thread.new do

  		EventManage::register_event(Proc.new do |r|
        p r
        Net::send_with_recv("0001asdfasdfasdf\0",r)
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
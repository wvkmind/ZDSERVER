
DataBase._redis_.set("testkey","testvalue")
puts DataBase._redis_.keys("*")
puts DataBase._redis_.get("testkey")
i = 1
EventManage::register_event(Proc.new do |r|
    i = i + 1
    Net::send_with_recv("recive#{i}\0",r)
end,{
    :name=>:V,:type=>:normal
})


#数据存储
DataBase._redis_.set("testkey","testvalue")
puts DataBase._redis_.keys("*") 
puts DataBase._redis_.get("testkey")
EventManage::register_event(Proc.new do |r|
    Net::send_with_recv("version:0.0.1\0",r)
end,{
    :name=>:V,:type=>:normal
})

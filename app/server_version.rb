
EventManage::register_event(Proc.new do |r|
    Net::send_with_recv("version:0.0.1\0",r)
end,{
    :name=>:V,:type=>:normal
})



EventManage::register_event(Proc.new do |r|
    Net::send_with_recv("#{DataBase._redis_.get("my_id")}\0",r)
end,{
    :name=>:get_my_id,:type=>:normal
})
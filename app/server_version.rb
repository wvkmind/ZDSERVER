
EventManage::register_event(Proc.new do |r|
    Net::send_with_recv("version:0.0.1\0",r)
end,:version)



EventManage::register_event(Proc.new do |r|
    Net::send_with_recv("#{r[:name]}:#{DataBase._redis_.get("my_id")}\0",r)
end,:get_my_id)

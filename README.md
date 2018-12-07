# Model

>存储数据
>/model

```ruby
class  TestModel < BaseModel
	def not_null
    	[:not_null_column]#这些字段检查不能为空
    end
    def uniq_value
    	[:a,:b]#这些字段检查唯一性
    def uniq_vlaues
    	[[:a,:b]]#这些字段组检查唯一性
    end
end

model = TestModel.new
model[:some_column] = 1
model[:other_column] = 2
model.save

model = TextModel.create({some_column: 1})

model = TextModel.find_by_id(1)
real_data = model[0]

model = TextModel.find_by(:some_column,1)
    			 .find_by(:other_column,
                     	  ->r{
                     			somefunction(f)#return bool
                          })
real_data = model[0]
real_data.to_h #取出Hash，为了返回客户端
```
>Event
```ruby
ServerConfig::NODE_TYPE #服务器node类型

Net::Connector.registerlogic('ping',-> params,my_node do
    begin
        if(!my_node.flush_heartbeat(params[:user_id]))
        	raise Exception.new('You are out.') 
        else
            my_node.send({status: 0},params) 
    rescue Exception => e
        my_node.send({error:e.message},params)
    end
end)

#ping :event name
#params :client data
#my_node: client cur node
#my_node.send(Hash[传一个Hash],params[为了node知道你是谁])
```

> Timer

```ruby
Timer.register(1000*30,->{node.check_heartbeats})
```

> LOG

```ruby
Log.info("xxxxxx")
```


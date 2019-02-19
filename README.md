# ZDSERVER

>存储数据
>/model

ActiveRecord

>Event

```ruby
ServerConfig::NODE_TYPE #服务器node类型

Net::Connector.registerlogic('ping',-> params,my_node do
    begin
        if(!my_node.flush_heartbeat(params[:user_id]))
            raise ServerException.new('You are out.')
        else
            my_node.send({status: 0},params)
        end
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

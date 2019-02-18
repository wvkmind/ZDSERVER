# -*- coding: utf-8 -*-
class Node < Net::Connector

    DataBase.add_remove("Node_*")

    def self.create(node_id)
        node = Node.new(ServerConfig::NODE_TYPE[:logic],NetConfig::IP,0)
        node.init_node(node_id)
        Timer.register(300,->{node.check_heartbeats})
        node
    end

    def clients
        @clients
    end
    def init_node(node_id)
        @node_id = node_id
        @clients = {}
    end

    def available(user_id)
        if @clients.keys.length>=NetConfig::NODE_LIMIT
            return false
        else
            return true
        end
    end

    def node_users
        @clients.keys
    end

    def remove_users(user_id)
        Room.out_room(user_id)
        user = User.loginout(user_id)
        Session.loginout(user[:account])
        @clients.delete(user_id)
    end

    def init_heartbeat(user_id,ip,port)
        if(!node_users.include?(user_id)&&!DataBase._redis_.exists("Node_#{@node_id}_H_#{user_id}"))
            DataBase._redis_.setex("Node_#{@node_id}_H_#{user_id}",300,"live")
            @clients[user_id] = 0
            user = User.get_user(user_id)
            user.set_ip_port({ip:ip ,port:port})
            user.set_node(self)
            return true
        else
            return false
        end
    end

    def flush_heartbeat(user_id,ip,port)
        if(node_users.include?(user_id)&&DataBase._redis_.exists("Node_#{@node_id}_H_#{user_id}"))
            DataBase._redis_.expire("Node_#{@node_id}_H_#{user_id}",300)
            @clients[user_id] = 0
            user = User.get_user(user_id)
            user.set_ip_port({ip:ip ,port:port})
            user.set_node(self)
            return true
        else
            return false
        end
    end

    def check_heartbeats
        @clients.each do |key,value|
            remove_users(key) unless DataBase._redis_.exists("Node_#{@node_id}_H_#{key}")
        end
    end
    
end

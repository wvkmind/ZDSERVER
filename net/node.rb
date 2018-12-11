# -*- coding: utf-8 -*-
class Node < Net::Connector

    def self.create(node_id)
        node = Node.new(ServerConfig::NODE_TYPE[:logic],NetConfig::IP,0)
        node.init_node(node_id)
        Timer.register(1000*30,->{node.check_heartbeats})
        node
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
        user = User.loginout(user_id)
        Session.loginout(user[:account])
        @clients.delete(user_id)
    end

    def init_heartbeat(user_id,ip,port)
        if(!node_users.include?(user_id)&&!DataBase._redis_.exists("Node#{@node_id}_H_#{user_id}"))
            DataBase._redis_.setex("Node#{@node_id}_H_#{user_id}",30,"live")
            @clients[user_id] = {ip: ip,port: port}
            return true
        else
            return false
        end
    end

    def flush_heartbeat(user_id,ip,port)
        if(node_users.include?(user_id)&&DataBase._redis_.exists("Node#{@node_id}_H_#{user_id}"))
            DataBase._redis_.expire("Node#{@node_id}_H_#{user_id}",30)
            @clients[user_id] = {ip: ip,port: port}
            return true
        else
            return false
        end
    end

    def check_heartbeats
        node_users.each do |u|
            remove_users(u) unless DataBase._redis_.exists("Node#{@node_id}_H_#{u[:id]}")
        end
    end
    
end

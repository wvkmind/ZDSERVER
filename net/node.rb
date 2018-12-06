# -*- coding: utf-8 -*-
class Node < Net::Connector

    def self.create(node_id)
        node = Net::Connector.new(ServerConfig::NODE_TYPE[:logic],NetConfig::IP,0)
        node.set_node_id(node_id)
    end

    def set_node_id(node_id)
        @node_id = node_id
    end

    def port
        @node.port
    end

    def available(user_id)
        if DataBase._redis_.scard("Node#{@node_id}_U")>=NetConfig::NODE_LIMIT
            return false
        else
            DataBase._redis_.sadd("Node#{@node_id}_U",user_id)
        end
    end

    def node_users
        DataBase._redis_.smembers("Node#{@node_id}_U")
    end

    def remove_users(user_id)
        DataBase._redis_.srem("Node#{@node_id}_U",user_id)
    end

    def flush_heartbeat(user_id)
        DataBase._redis_.setex("Node#{@node_id}_H_#{user_id}",30,user_id)
    end

    def check_heartbeats
        users = []
        DataBase._redis_.keys("Node#{@node_id}_H_*").each do |key|
            users << DataBase._redis_.get(key)
        end
        node_users.each do |u|
            remove_users(u) unless users.include?(u)
        end
    end
end

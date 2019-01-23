class Labby
    REDIS_STR = "LabbyUserList"
    DataBase.add_remove(REDIS_STR)
    def self.join_labby(user_id)
        DataBase._redis_.sadd(REDIS_STR)
    end
    def self.out_labby(user_id)

    end
    def self.chat(msg)

    end
end
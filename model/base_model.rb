#[TODO] key value 打包然后根据id存入redis ，根据id能取到
class BaseModel
    
    def initialize
        @attributes = {} 
    end

    def not_null
        #不能为空
        [:id]
    end

    def uniq_vlaue
        #单个唯一
        [:id]
    end

    def uniq_vlaues
        #组个唯一
        []
    end

    def set_attributes(attributes)
        @attributes = attributes
    end
    
    def [](key)
        @attributes[key]
    end

    def []=(key,value)
        @attributes[key] = value
    end

    def save
        save_reids
    end

    def save_reids
        self.not_null.each do |key|
            raise "#{self.class} #{key} cannot be null." if self[key].nil?
        end
        
        self[:id] = DataBase._redis_.incr("#{self.class}_maxid")  if self[:id].nil?
        
        keys = []
        begin
            self.uniq_vlaue.each do |key|
                raise "#{self.class} #{key} have #{self[key].to_s} " unless DataBase._redis_.setnx("#{self.class}_uniq_#{key}_#{self[key].to_s}",self[:id]) || DataBase._redis_.get("#{self.class}_uniq_#{key}_#{self[key].to_s}")==self[:id]
                keys << "#{self.class}_uniq_#{key}_#{self[key].to_s}"
            end
            self.uniq_vlaues.each do |keys|
                value = ""
                keys.each do |key|
                    value = value + self[key].to_s
                end
                raise "#{self.class} #{keys.join(':')} have #{value} " unless DataBase._redis_.setnx("#{self.class}_uniqs_#{keys.join(':')}_#{value}",self[:id]) || DataBase._redis_.get("#{self.class}_uniqs_#{keys.join(':')}_#{value}")==self[:id]
                keys << "#{self.class}_uniqs_#{keys.join(':')}_#{value}"
            end
            DataBase._redis_.set("#{self.class}_#{self[:id]}",Marshal.dump(@attributes))
            keys << "#{self.class}_#{self[:id]}"
        rescue => exception
            DataBase._redis_.del(keys) if keys.length>0
            throw exception
        end
        
    end

    def get_reids(id)
        if DataBase._redis_.exists("#{self.class}_#{id}")
            set_attributes(Marshal.load(DataBase._redis_.get("#{self.class}_#{id}")))
        else
            return nil
        end
    end
    
    def self.create(attributes)
        m = self.new
        m.set_attributes(attributes)
        m.save_reids
    end

    def self.find_by_id(id)
        m = self.new 
        if m.get_reids(id)!=nil
            m
        else
            nil
        end
    end

    def to_s
        "Model:#{self.class}:#{self.object_id}:#{@attributes}"
    end

end
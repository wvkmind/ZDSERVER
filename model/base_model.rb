#[TODO] key value 打包然后根据id存入redis ，根据id能取到
class BaseModel
    
    def initialize
        @attributes = {} 
    end

    def set_attributes(attributes)
        @attributes = attributes
    end

    def save_reids
        
    end

    def get_reids(id)
        
    end
    
    def self.create(attributes)
        m = self.new
        m.set_attributes(attributes)
        m.save_reids
    end

    def self.find_by_id()

    end

end
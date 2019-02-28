class Item
    FOODMAX=37
    GARBAGE=11

    def initialize(pool)
        pos = []
        pool_count = 0
        pool.each_with_index do |p,i|
            pos[pool_count] = i
            pool_count = pool_count + 1 if p.nil?
        end
        if pool_count == 0
            raise "Item pool Max"
        end
        create(pool_count,pos)
    end

    def create(pool_count,pos)
        @owner = -1
        @energy = -1
        Random.srand(Random.new_seed)
        @type = Random.rand(0..1)
        if @type == 1
            Random.srand(Random.new_seed)
            @id = Random.rand(0..FOODMAX)
            @energy = DataConfig::FOODENERGY[@id]
        else
            Random.srand(Random.new_seed)
            @id = Random.rand(0..GARBAGE)
        end
        Random.srand(Random.new_seed)
        c = Random.rand(0...pool_count)
        @pos = pos[c]
    end

    def eat(user_id)
        @owner = user_id
        if(@energy>=1)
            @energy = @energy - 1
        end
        cancel_eat if(@energy==0)
        @energy != 0
    end

    def cancel_eat
        @owner = -1
    end

    def energy
        @energy
    end

    def is_food?
        @type == 1
    end

    def is_garbage?
        @type == 0
    end

    def get_id
        @id
    end

    def pos
        @pos
    end

    def type
        @type
    end
    
    def owner
        @owner
    end

    def to_client
        if(is_food?)
            {type: @type,id: @id,pos: @pos,owner:@owner,energy:@energy.to_f/DataConfig::FOODENERGY[@id].to_f}
        else
            {type: @type,id: @id,pos: @pos,owner:-1,energy:-1}
        end
    end
end
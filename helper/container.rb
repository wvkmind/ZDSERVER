module Container
    class Box
        @@box = {}
        def self.put(name,i)
            @@box[name] = i
        end
        def self.get(name)
            @@box[name]
        end
        def self.box
            @@box
        end
    end
end

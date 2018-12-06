class Array
    def find_by(key,p)
        ret = []
        self.each do |v|
            ret << v if(p.class == Proc&&p.call(v[key]))||p == v[key]
        end
        ret
    end
end

def update_dir path,need_reload_file
    Dir.entries(path).each do |e| 
            if e[0] !='.' and 
                    e = path+ '/' + e
                    if File::ftype(e)=='directory' 
                            update_dir e,need_reload_file
                    elsif (File::ftype(e)=='file') and (e[(e.length-3)..(e.length-1)]=='.rb') 
                            need_reload_file[e] = true 
                    end
            end
    end
end
def init(path)
    need_reload_file = {}
    update_dir path,need_reload_file
    up_queue = need_reload_file.sort 
    up_queue.each do |e|
        require e[0] 
    end
end

init('./log')
init('./database')
init('./net')
init('./config')
init('./helper')
init('./app')
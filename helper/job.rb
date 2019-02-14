class Job
    @@jobs = Queue.new
    def self.add(proc)
        @@jobs << proc
    end
    def self.run
        Thread.new do
            begin 
                loop do
                    job = @@jobs.pop
                    job.call
                end
            rescue Exception => e  
                Log.info e.message	
                Log.info e.backtrace
                retry
            end
        end
    end
end
require 'logger'
module Log
  def self.info(info)
    Logger.new('./log/all.log').info info
    Logger.new('./log/all.log').info "_____________________________________________"
  end
  def self.re(info)
  	if info.class == 'String'
  		info(info) 
  	else
    	Logger.new('./log/all.log').info info.message
    	info.backtrace.each do |variable|
    		Logger.new('./log/all.log').info variable 
    	end
    	Logger.new('./log/all.log').info "_____________________________________________"
    end
  end
end
require 'singleton'
require './element/element'
require './timer/timer.rb'
module WorldRoot

	def self.instance
		WorldRoot::Root.instance
	end

	class Root
  		include Singleton
 		def initialize
 			@world = Element.new('world_end.png')
 			update_proc = Proc.new do 
 				WorldRoot.instance.get_world.each do |element|
          			element.update 
      			end
 			end
 			Timer::register(0.033,update_proc)
 		end
 		def get_world
 			@world
 		end
 		def put_element e
 			@world.set_children e
 			e
 		end
  	end
 
 end
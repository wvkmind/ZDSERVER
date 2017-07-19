#wvkmind
#element with state machine
#have Timer to change pictrue 
#state machine to select picture 
#state change have three process : before , ing ,end
#before to do some prepare work ,and the ing mainly do some like change picture work,
#and the end is unregister thie timer and so on . 
require './element/element'
class ElementWS < Element
	def initialize
		super.init_addtr
		@state_pool	  = {}
		@texture_hash = []
	end
	def add_state(info)
		before_proc  = info[:before ]
		ing_proc     = info[:ing    ]
		end_proc     = info[:end    ]
		texture_arry = info[:textrue]
		timer_info   = info[:timer  ]
		

	end
end
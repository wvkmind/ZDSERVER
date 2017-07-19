# coding: GBK
require 'opengl'
require 'glu'
require 'glut'
require './log/log'
require './resource_management/texture_management'
class Element
	include Gl
  	include Glu
  	include Glut
	def initialize(file)
		init_addtr
		set_textrue(file)
	end

	def init_addtr
		@textrue  = nil
		@x        = 0.0
		@y        = 0.0
		@width    = 0.0
		@height   = 0.0
		@scale    = 1.0 
		@visible  = true
		@order    = 0
		@children = []
		@parent   = nil
		@anchor   = {:x=>0.0,:y=>0.0}
	end

	def set_anchor(x,y)
		@anchor[:x] = x.to_f
		@anchor[:y] = y.to_f
	end

	def get_anchor
		@anchor
	end

	def set_position(x,y)
		@x = x.to_f
		@y = y.to_f
	end

	def set_content_size(width,height)
		@width  = width.to_f
		@height = height.to_f
	end

	def set_scale(f)
		@scale = f.to_f
	end

	def get_position
		{:x=>@x,:y=>@y}
	end

	def get_content_size
		{:width=>@width,:height=>@height}
	end

	def get_scale
		@scale
	end

	def delete_me
		Texture::delete_textrue(file) unless @textrue==nil
	end

	def set_textrue(file)
		Texture::delete_textrue(file) unless @textrue==nil
		update_textrue(file)
	end
	#用下面的就要自己控制资源的释放
	#适用于动态动作这种
	def update_textrue(file)
		info = Texture::need_textrue(file)
		@textrue = info[:textrue]
		@width   = info[:width]
		@height  = info[:height] 
	end

	def draw
		if @textrue != nil and @visible == true 
			glBindTexture GL_TEXTURE_2D, @textrue[0]
			glBegin GL_QUADS do
				glTexCoord2f(0.0, 1.0)
				glVertex3f(@x-@anchor[:x]*@scale*@width, @y-@anchor[:y]*@scale*@height,  0.0)
				glTexCoord2f(1.0, 1.0)
				glVertex3f(@x+@scale*@width-@anchor[:x]*@scale*@width,@y-@anchor[:y]*@scale*@height,  0.0)
				glTexCoord2f(1.0, 0.0)
				glVertex3f( @x+@scale*@width-@anchor[:x]*@scale*@width, @y+@scale*@height-@anchor[:y]*@scale*@height,  0.0)
				glTexCoord2f(0.0, 0.0)
				glVertex3f(@x-@anchor[:x]*@scale*@width,  @y+@scale*@height-@anchor[:y]*@scale*@height,  0.0)
    		end
    	end
	end

	def get_childrens
		@children
	end

	def set_children(element)
		order = element.get_order.to_i
		@children[order] = [] if @children[order] == nil
		element.set_parent self
		@children[order].push(element)
	end

	def delete_children(element)
		order = element.get_order.to_i
		return false if @children[order] == nil
		@children[order].delete(element)
	end

	def set_order(f)
		@parent.delete_children(self)
		@order = f.to_i
		@order = -@order if @order<0
		@parent.set_children(self)
	end

	def get_order
		@order
	end

	def set_parent(f)
		@parent = f
	end

	def get_parent
		@parent
	end

	def each
		yield self
		@children.each do |order_c|
			if order_c != nil
				order_c.each do |c|
					yield c
				end
			end
		end
	end

	def update

	end

end






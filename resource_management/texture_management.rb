# coding: GBK
require 'opengl'
require 'glu'
require 'glut'
require 'chunky_png'
require 'singleton'
require './log/log'

#清除资源和加载资源时候的锁
delete_resource_mutex = Mutex.new

module Texture

	def self.need_textrue(file)
		Texture::TextureManagement.instance.add(file)
	end

	def self.delete_textrue(file)
		Texture::TextureManagement.instance.delete(file)
	end

	def self.get_textrue(file)
		Texture::TextureManagement.instance.get_pool(file)
	end

  def self.fix_dynamic_resource_authority
    Texture::TextureManagement.instance.fix_dynamic_resource_authority
  end

	class TextureManagement

  		include Gl
  		include Glu
  		include Glut
  		include Singleton

  		def initialize
			 @resource_pool                 = {}
			 @resource_load_frequent_degree = {}
			 super
  		end
  		def get_pool(file)
  			@resource_pool[file]
  		end
  		##########################################################################
  		
  		def delete(file)
  				tmp = @resource_load_frequent_degree[file]
  				if tmp == nil 
					 tmp = 0
				  else
					 tmp = tmp - 1
  				end
  				@resource_load_frequent_degree[file] = tmp
  		end

  		def add(file)
  			ret = insert_one(file)
  			tmp = @resource_load_frequent_degree[file]
				tmp = 0 if tmp == nil 
				tmp = tmp + 1
			 	@resource_load_frequent_degree[file] = tmp 
  			ret 
  		end
  		
  		def fix_dynamic_resource_authority
  			#把没有在被使用的资源移除
  			delete_resource = []
  			@resource_load_frequent_degree.each do |key,count|
  				delete_resource.push(key) if count == 0 
  			end
  			delete_resource.each do |d|
  				@resource_pool.delete(d)if count == 0 
  			end
  		end
  		##########################################################################
  		#加资源
  		def insert_one(file)
        return @resource_pool[file] if @resource_pool[file] != nil 
  			ret = load_png_textrue(file)
  			@resource_pool[file] = ret 
  			return ret
  		end

  		def load_png_textrue(file)
          begin
            container = glGenTextures 1
            glBindTexture GL_TEXTURE_2D, container[0]
      		  png = ChunkyPNG::Image.from_file(File.expand_path('./resource/'+file))
      		  height = png.height
      		  width = png.width
      		  image = png.to_rgba_stream.each_byte.to_a
            glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
            glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
            glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
      		  {:height => height,:width => width,:textrue =>container}
          rescue Exception => e  
            Log.re e
          end
  		end

  	end

end
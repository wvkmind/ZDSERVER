# coding: utf-8
require 'opengl'
require 'glu'
require 'glut'
require 'chunky_png'
require './log/log'
require './world/world_root'
require './input_event/key_board'
require './input_event/mouse'
require 'singleton'
class GlutLoop
  include Gl
  include Glu
  include Glut

  def initialize f
    @fullscreen = true
    glutInit
    glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH
    glutInitWindowSize 800, 600
    glutInitWindowPosition 0, 0
    @window = glutCreateWindow f
    glBlendFunc GL_SRC_ALPHA, GL_ONE
    glEnable GL_BLEND
    glEnable(GL_LINE_SMOOTH)
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutKeyboardFunc :keyboard
    glutKeyboardUpFunc :keyUpboard

    glutMouseFunc :mouseUpDown
    glutMotionFunc :mouseMove
    glutPassiveMotionFunc :mouseDownMove
    glutEntryFunc :mouseEntry

    reshape 800, 600
    init_gl
    

  end
  def loop
    glutMainLoop
  end
  def init_gl
    glEnable GL_TEXTURE_2D
    glShadeModel GL_SMOOTH
    glClearColor 0.0, 0.0, 0.0, 0.5
    glClearDepth 1.0
    glEnable GL_DEPTH_TEST
    glDepthFunc GL_LEQUAL
    glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
  end

  def reshape width, height
    width   = width.to_f
    height = height.to_f
    height = 1.0 if height.zero?
    glViewport 0, 0, width, height
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    gluOrtho2D(0,800,0,600)
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
  end

  def draw_gl_scene
    begin
      glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
      glMatrixMode GL_MODELVIEW
      glLoadIdentity
      #update
      WorldRoot.instance.get_world.each do |element|
          element.draw 
      end
      Texture::fix_dynamic_resource_authority
      
      glutSwapBuffers
    rescue Exception => e  
       Log.info e.message  
       Log.info e.backtrace
    end
  end

  def idle
    glutPostRedisplay
  end
  #键盘事件
  #抬起
  def keyUpboard(key,x,y)
    KeyBoard::Event.instance.do_down_key(key,x,y)
  end
  #按下
  def keyboard(key, x, y)
    KeyBoard::Event.instance.do_up_key(key,x,y)
  end

  #鼠标事件
  #鼠标按键抬起和按下的状态
  def mouseUpDown(button,state,x,y)
    Mouse::Event.instance.do_up_down(button,state,x,y)
  end
  #鼠标按下移动
  def mouseDownMove(x,y)
    Mouse::Event.instance.mouseDownMove(x,y)
  end
  #鼠标抬起移动
  def mouseMove(x,y)
    Mouse::Event.instance.mouseMove(x,y)
  end
  #鼠标进入
  def mouseEntry(state)
    Mouse::Event.instance.mouseEntry(state)
  end

end
def 创建世界 f
  main_world = GlutLoop.new f
end
def 启动(f)
    f.loop
end
def 创建一个元素 (f)
  one = Element.new(f)
  WorldRoot::instance.put_element one
end

def 启动自动启动
  load './auto_load/auto_load.rb'
end

def re_test(key,proc)
  KeyBoard::Event.instance.key_down_register(key,proc)
end
require "class/image.rb"
class Hit
  include Obj
  def initialize(own,r)
    @owner = own
    @r = r
    @x = @owner.x
    @y = @owner.y
    @w = r
    @h = r
    @visible = false
    set_layer(own.layer)
    move
  end
  def move
    draw
    @layer = @owner.layer
    @x = @owner.x
    @y = @owner.y
  end 
  def draw
    if @visible
      $screen.fill_rect(@x+$scroll.x-@r/2,@y+$scroll.y-@r/2,@r,@r,[255,0,0])
    end
  end
  def size(n)
    @r = n
    @w = n
    @h = n
  end
  attr_accessor :visible,:x,:y,:w,:h,:r
end

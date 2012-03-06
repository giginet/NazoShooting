require "class/object.rb"
require "class/shot.rb"
module Chara
  include Obj
  include Shot
  def initialize(x=0,y=0,fn="")
    @x=x
    @y=-y
    @z=100
    @score = 100
    @ground = true
    @v =Vector.new(0,0)
    @speed = 10
    $stage_que.push(self)
    @@chara_id ||=0
    @@chara_id++
      @id = @@chara_id
    #喰らい無敵フラグ
    @inv = Timer.new(5)
    @finv = false
    load_image(fn)
    @hp = 1
    @attack = 1
    set_layer(0)
    @hitarea = Hit.new(self,20)
    @bombtype = :normal
  end 
  def mychara?
    return false
  end
  def start_inv
    @inv.play
  end
  def pop
    $charas.push(self)
  end
  def disable_hit
    @hitarea.size(0)
  end
  def common
    hit
    #喰らい無敵の点滅
    if @inv.up? && @inv.move?
      @finv = false
      @inv.stop
    end
    if @inv.move?
      a = (Math.sin(@inv.now*30*Math::PI/180)*30+50)
      @image.alpha(a)
    else
      @image.alpha(100)
    end
    @hitarea.move
  end
  def hit
    $bullets.each do |b|
      if @hitarea.hitTest(b) && mychara? != b.mine?
        if !@finv 
          @hp -=b.attack  
          s = SE.new("bosu01.wav")
          s.play
          if @hp <= 0
            destroy
            $my.get_score(@score)
          else
            @inv.reset
            @inv.play
            @finv = true
          end
        else
          i = SE.new("metal12.wav")
          i.play
        end
        if !b.through
          b.destroy
        end
      end
    end
  end
  attr_accessor :x,:y,:v,:id,:hitarea,:speed
  attr_reader :w,:h,:attack,:bombtype
end

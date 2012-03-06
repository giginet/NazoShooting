require "class/object.rb"
require "class/form.rb"
class Bullet
  include Obj
  include Form
  def initialize(obj,x=obj.x,y=obj.y)
    if $bullets.length >128
      $bullets.shift
    end
    @owner = obj
    @x=x
    @y=y
    @z=0
    @speed = 12
    @v = Vector.new(0,1)
    change(15)    
    @time = Timer.new
    @time.set(600)
    @time.play
    begin 
      @@bullet_id +=1
    rescue
      @@bullet_id = 0
    end
    @id = @@bullet_id
    #攻撃力
    @attack = @owner.attack
    @forms = Hash.new
    @through = false
    $bullets.push(self)
    @bomb = false
    set_layer(@owner.layer)
    #puts layer
    load_image("bullet.png")
  end
  def act
    sign
    acl
    homing
    rotate
    if !in?
      destroy
    end
  end
  def move
    act
    @x +=@v.x
    @y +=@v.y
  end
  def destroy
    $bullets-=[self]
  end
  def mine?
    return $my == @owner && !@mine
  end
  def change(n)
    if mine?
      @speed = -1*n 
    else
      @speed = n
    end
    @v.resize(@speed)
  end
  def image(fn)
    load_image(fn)
  end
  def limit(n)
    @time.set(n)
  end
  def set_rotate(cx,cy,rs)
      @cx = cx
      @cy = cy
      @rs = rs
      forms[:rotate] = true
  end
  #弾が他の持ち主かどうか
  def another?(id)
    return owner != id
  end
  def through(f=nil)
    if f !=nil
      forms[:through] = f
    end
    return forms[:through]
  end
  attr_accessor :x,:y,:v,:speed,:forms,:bomb
  attr_reader :owner,:w,:h,:id,:attack
end
#爆風クラス
class Bomb < Bullet
  def initialize(obj,x=obj.x,y=obj.y)
    super
    type = obj.bombtype
    graphics = {:normal=>"bomb",:big=>"bomb"}
    sounds = {:normal=>"bom24.wav",:big=>"bom33.wav"}
    image(graphics[type])
    @image.loop?(false)
    @bomb = true
    s= SE.new(sounds[type],12)
    change(0)
    s.play
  end
  def act
    super
    @image.loop?(false)
    if @image.up?
      destroy
    end
  end
end
#上下を移動する弾道のクラス
class Updown < Bullet
  def initialize(obj,x=obj.x,y=obj.y)
    super
    @mid = true
    @image.loop?(false)
    image("downshot")
    #目的地座標
    @gx =0
    @gy =0
    @speed = 0
    @image.delay(3)
    @v = Vector.new
    @dropping = Timer.new(10)
  end
  def act
    if @dropping.up? && @mid
      @mid =false
      @layer = 1
      @speed = 0
    elsif !@mid && @dropping.up?
      destroy
    else
      super
    end
  end
  def drop_point(x,y)
    @gx = x
    @gy = y
    @v = Vector.new(@gx-@x,@gy-@y)
    @v *=0.1
    @dropping.play
  end
  def destroy
    super
    b = Bomb.new(@owner,@gx,@gy)
    b.set_layer(1)
    b.speed = 0
    b.v = Vector.new
  end
end

module Form
  def homing
    if @forms[:homing] && !mine?
      dx = $my.x - @x
      dy = $my.y - @y
      @v += Vector.new(dx,dy)
      @v.resize(speed.abs)
    end
  end
  def sign
    if @forms[:sign]
      if @sign.nil?
        @sign = 0
      end
      r = 100
      rd = @sign*Math::PI/180
      @v += Vector.new(2*r*Math.cos(rd),10)
      @v.resize(@speed)
      @sign +=20
    end
  end
  def acl
    if @forms[:acl]
      if @speed< 20
        sp = @speed*1.1
        change(sp)
      end
    end
  end
  def rotate
    if @forms[:rotate]
      dx = @x-@cx
      dy = @y-@cy
      v = Vector.new(dx,dy)
      v.rotate!(@rs)
      @x = @cx+v.x
      @y = @cy+v.y
      @cx +=@v.x
      @cy +=@v.y
    end
  end
end

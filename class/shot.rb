module Shot
    def three_way
        b1 = Bullet.new(self,@x,@y-72)
        b2 = Bullet.new(self,@x+48,@y-24)
        b3 = Bullet.new(self,@x-48,@y-24)
        b1.image("ray.png")
        b2.image("ray.png")
        b3.image("ray.png")
        #b1.v.set(0,1)
        #b1.v.resize(@speed)
        #b2.v.set(1,1)
        #b2.v.resize(@speed)
        #b3.v.set(-1,1)
        #b3.v.resize(@speed)
    end
    #自機専用弾
    def my_level1
        b1 = Bullet.new(self)
        b1.image("ray.png")
    end
    def my_level2
        b1 = Bullet.new(self,@x+10,@y)
        b2 = Bullet.new(self,@x-10,@y)
        b1.image("ray.png")
        b2.image("ray.png")
    end
    def my_level3
        three_way
    end
    #通常弾
    def normal
        rv = @v
        #rv *= 0.2
        bullet = Bullet.new(self)
        bullet.v +=rv
        return bullet
    end
    def set_skill
        @skills = {:direction=>method(:direction),
            :sign=>method(:sign),
            :normal=>method(:normal),
            :homing=>method(:homing),
            :acl=>method(:acl),
            :circle=>method(:circle),
            :multiple=>method(:multiple),
            :wide=>method(:wide),
            :laser=>method(:laser),
            :upshot=>method(:upshot),
            :star=>method(:star),
            :cross=>method(:cross),
            :summon=>method(:summon)
        }
    end
    #方向弾
    def direction  
        b = Bullet.new(self)
        dx = $my.x-@x 
        dy = $my.y-@y
        b.v.set(dx,dy)
        b.change(5)
        b.v.resize(b.speed)
    end
    #正弦弾
    def sign
        b=Bullet.new(self) 
        b.forms[:sign] = true
        b.change(10)
    end
    #誘導弾
    def homing
        b = normal
        b.forms[:homing] = true
        b.change(2)
        b.limit(300)
    end

    #加速弾
    def acl  
        b = normal
        b.change(0.1)
        b.forms[:acl] = true
    end
    #円形弾
    def circle
        for i in 0..360
            if i%30 ==0
                rd = (i*Math::PI)/180
                r = 20
                b=Bullet.new(self,r*Math.cos(rd)+@x,r*Math.sin(rd)+@y)
                b.change(2)
                sp = b.speed.abs
                b.v.set(sp*Math.cos(rd),sp*Math.sin(rd))
            end
        end
    end
    #拡散弾
    def multiple  
        rx = rand(1000)-500
        ry = 200+rand(800)
        b = Bullet.new(self)
        b.v.set(rx,ry)
        b.change(5)
    end
    def upshot
        @count ||=0
        if @count<3
            b = Bullet.new(self)
            dx = $my.x-@x 
            dy = $my.y-@y
            b.v.set(dx,dy)
            b.change(2)
            b.v.resize(b.speed)
            b.set_layer(0)
            @count +=1
            frq(10)
        else
            @count = 0
            frq(100)
        end
    end
    def wide
        @angle ||=0
        r = 40
        x = Math.cos(atr(@angle))*r
        y = Math.sin(atr(@angle))*r
        b = Bullet.new(self,@x+x,@y+y)
        b.v = Vector.new(x,y)
        b.change(5)
        b.v.resize(b.speed)
        @angle=(@angle+10)%120+45
    end
    def laser
        frq(2)
        r = Bullet.new(self)
        r.image("laser.png")
        r.through(true)
        r.speed = 10
    end
    def star
        @count ||=0 
        @starx ||= @x-20*3
        @stary ||= @y-20*0.75
        @starv ||=Vector.new(1,0)
        @stars ||=Array.new
        @starv.resize(20)
        if @count < 30
            @starx+=@starv.x
            @stary+=@starv.y
            b = Bullet.new(self,@starx,@stary)
            b.change(0)
            @stars.push(b)
            @count+=1
            if @count%6 == 0
                @starv.rotate!(144)
            end
        else
            @stars.each do |s|
                dx = $my.x-@x
                dy = $my.y-@y
                s.v = Vector.new(dx,dy)
                s.v.resize(10)
                s.set_rotate(@x,@y,5)
            end
            @count = 0
            @starx = @x-20*3
            @stary = @y-20*0.75
            @starv =Vector.new(1,0)
            @stars =Array.new
        end
    end
    def cross
        @rotation ||= 0
        (0..7).to_a.each do |i|
            rad = atr(45*i+@rotation)
            v = Vector.new(Math.cos(rad),Math.sin(rad))
            v.resize(40)
            b = Bullet.new(self,@x+v.x,@y+v.y)
            v.resize(3)
            b.v = v
        end 
        @rotation +=15
    end
    def summon
      f = Zako1.new(@x,-@y)
      v = Vector.new($my.x-@x,$my.y-@y)
      v*=10
      f.set_move(@x+v.x,@y+v.y,true)
    end
end

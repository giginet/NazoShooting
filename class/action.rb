class Action
    def initialize(obj)
        @owner = obj
        @x = obj.x
        @y = obj.y
        @v = Vector.new
        @gx = 0
        @gy = 0
        @moving = false
    end
    def act
    end
    def set_que
        @owner.set_que(self)
    end
    def deque
        @owner.v = Vector.new
    end
    def move?
    end
    def up?
    end
end
class MoveAct < Action
    def initialize(obj,x,y,flag=false)
        super(obj)
        set_move(x,y)
        @shot = flag
    end
    #移動先座標、移動中に攻撃するかどうかbool
    def set_move(x,y)
        @gx = x
        @gy = -y
        @owner.moving = true
        @type = 0
    end
    def up?
        #移動するとき
        d = Math.sqrt((@gx-@owner.x)**2+(@gy-@owner.y)**2)
        b = d < @owner.speed*2
        if b
           @owner.moving = false 
        end
        return b
    end
    def act
        @owner.toggle_shot(@shot)
        dx = @gx - @owner.x
        dy = @gy - @owner.y
        @owner.v = Vector.new(dx,dy)
        @owner.v.resize(3)
    end
end
class ShotAct < Action
    def initialize(obj,limit)
        super(obj)
        @limit = limit
        @count = 0
    end
    def act
        if @count <= @limit
            #@owner.can_shot = true
            if @owner.shot
                @count+=1
            end
        end
    end
    def up?
        return @count > @limit
    end
end
class WaitAct < Action
    def initialize(obj,limit)
        super(obj)
        @timer = Timer.new(limit)
        @timer.play
    end
    def up?
        return @timer.up?
    end
end

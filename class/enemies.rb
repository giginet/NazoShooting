require "class/enemy.rb"
class Meteor < Sky
    def initialize(x,y)
        super(x,y,"meteor.png")
        @speed = 10
        @speed = 12
        @score = 150
        @angle = 0
        @image.enable_alpha
    end
    def destroy
        super
        for i in 0...4
            a = Meteor2.new(@x,-@y)
            v = @v.duplicate
            v*=100
            v.rotate!((i-2)*rand(40))
            a.set_move(@x+v.x+@v.x,-(@y+v.y+@v.y))
            a.set_speed(15)
            a.start_inv
        end
        $stage.sort
    end
    def act
        common
        @angle +=60
        @image.alpha(90+10*Math.sin(atr(@angle)))
    end
    def pop
        super
        if @x >320
            x = @x-320
        else
            x = @x+320
        end
        @v = Vector.new(x-@x,$my.y-@y)
    end
    def shot
    end
end
class Meteor2 < Sky
    def initialize(x,y)
        super(x,y,"smeteor.png")
        @speed = 25
        @score = 100
        @angle = 0
        @image.enable_alpha
    end
    def shot
    end
    def act
        super
        @angle +=60
        @image.alpha(90+10*Math.sin(atr(@angle)))
    end
end
class Balloon < Sky
    def initialize(x,y)
        super(x,y,"balloon")
        @hp = 5
        @score = 300
    end
    def act
        super
        @image.at(5-@hp)
    end
end
class Cross < Sky
    def initialize(x,y)
        super(x,y,"cross")
        @type =:cross
        @score = 500
        @hp = 1
    end
end
class Tank < Canon
    def initialize(x,y)
        super(x,y,"tank2.png")
        @score = 300
        @speed = 1.5
    end
    def shot
        super
        load_image("tank1.png")
    end
    def act
        super
        if @v.length !=0
            load_image("tank2.png")
        end
    end
    def destroy
        super 
        $charas.reject!{|b|b.eql?(self)}
    end
end

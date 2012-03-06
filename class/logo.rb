class Logo
    def initialize(stage)
        @x = -200
        @y = 400
        @v = Vector.new(20,0)
        @image = Image.new(@x,@y,"stage#{stage}.png")
        @timer = Timer.new(100)
        @alpha = 100
    end
    def act
        if @x >410
            if !@timer.move?
                @v.set(0,0)
                @timer.play
            end
            if @timer.up?
                @timer.stop
                @v.set(0,10)
            end
        end
        @x +=@v.x
        @y +=@v.y
        @image.set_pos(@x,@y)
    end
    def render
        @image.render(true)
    end
end

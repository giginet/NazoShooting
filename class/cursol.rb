class Cursol
    include Obj
    def initialize(ary)
        @x = 0
        @y = 0
        load_image("cursol.png")
        @max = ary.length
        @pos = ary.dup
        @pushed = false
        reset
    end
    def reset
        @cursol = 0
        @selected = false
    end
    def act
        if !@pushed && !@selected
            max = @max
            if $input.down?
                @cursol =(@cursol+1)%max
            elsif $input.up?
                @cursol =(@cursol-1)%max
            end
        end
        @pushed =($input.down? || $input.up?)
        @x = @pos[@cursol][0]
        @y = @pos[@cursol][1]
        @image.x = @x
        @image.y = @y
        @image.render(true)
    end
    def enter?
        if !@selected && $input.enter?
            return true
        else
            return false
        end
    end
    def selected?
        return @selected
    end
    def now
        return @cursol
    end
    attr_accessor :selected
end

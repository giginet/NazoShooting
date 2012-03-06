module Obj
    #どのレイヤーにいるか
    #@layer = 0
    #落下中かどうか
    #@mid = false
    def up?
        return @layer==0 && !@mid
    end
    def down?
        return @layer==1 && !@mid
    end
    def layer
        if @mid
            return 2
        else
            return @layer
        end
    end
    def set_layer(l)
        @layer = l
        @mid = false
    end
    def past?
        return -@y < $scroll.y+50
    end
    def pop
        #@y = @popy-$scroll.y
    end
    def move
        act
        @v.resize(@speed)
        @x += @v.x
        @y += @v.y
    end
    def render
        if !in?
            destroy
        else
            #move
            animation
            @image.x = @x
            @image.y = @y
            @image.render
            begin
                @hitarea.draw
            rescue

            end
        end
    end
    def gravity
        if HOLIZON - @image.h > @y
            @v.y +=9.8/RATE
            @ground = false
        else
            @y = HOLIZON - @image.h
            if @v.y >0
                @v.y = 0
                @ground = true
            end
        end
    end
    def load_image(fn="")
        @image = Anime.new(@x,@y,fn)
        @w = @image.w
        @h = @image.h
    end
    def in?
        @y >-100-$scroll.y && @y<580-$scroll.y-@h && @x>-100-$scroll.x && @x<700-$scroll.x-@w
    end
    def in_screen?
        @y >0-$scroll.y && @y<480-$scroll.y-@h && @x>0-$scroll.x && @x<640-$scroll.x-@w
    end
    def hit_frame(d=false)
        flag = false
        if d
            if @y > 480-$scroll.y-@h/2
                @y = 480-$scroll.y-@h/2
                flag = true
            elsif @y<0-$scroll.y+@h/2
                @y = 0-$scroll.y+@h/2
                flag = true
            end
        end
        if @x > 640-$scroll.x-@w/2
            @x = 640-$scroll.x-@w/2
            flag = true
        elsif @x<0-$scroll.x+@w/2
            @x = 0-$scroll.x+@w/2
            flag = true
        end
        if @y > 480-$scroll.y
            destroy
        end
        return flag
    end
    def hitTest(obj)
        #矩形編
        #(obj.x < @x+@w && @x <obj.x) && (@y < obj.y && obj.y < @y+@h)
        #中心同士の距離で取る
        cx = @x + @w/2
        cy = @y + @h/2
        cx2 = obj.x + obj.w/2
        cy2 = obj.y + obj.h/2
        return ((cx-cx2).abs < obj.w/2+@w/2) && ((cy-cy2).abs < obj.h/2 + @h/2) && (layer==obj.layer)
    end
    def animation 
        if @image.anime?
            @image.animation  
        end
    end
    def loop?(f=nil)
        if f!=nil
            @image.loop?(f)
        end
    end
    private :gravity
    attr_accessor :x,:y
end

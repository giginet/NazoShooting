class Text
    def initialize(text="",x=0,y=0,size=24,color=[255,255,255])
        SDL::TTF.init
        @size = size
        begin
            @font = SDL::TTF.open("./font/font.otf",@size)
            @shadow_tf = SDL::TTF.open("./font/font.otf",@size)
        rescue
            puts "Font Error"
        end
        @x = x
        @y = y
        @text = text
        @r = color[0]
        @g = color[1]
        @b = color[2]
        @shadow = false
    end
    def draw(text="")
        unless text==""
            @text=text
        end
        begin
            if @shadow
                @shadow_tf.draw_blended_utf8($screen,@text.to_s,@x+@size*0.05,@y+@size*0.05,(@r*0.5).round,(@g*0.5).round,(@b*0.5).round)
            end
            @font.draw_blended_utf8($screen,@text.to_s,@x,@y,@r,@g,@b)
        rescue
            #puts "深刻なエラーが発生しました。"
        end
    end
    def color(r,g,b)
        @r = r
        @g = g
        @b = b
    end
    def enable_shadow
        @shadow = true
    end
end

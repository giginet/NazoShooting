require "class/image.rb"
class Anime < Image
    def initialize(x,y,fn="")
        ext = fn.scan(/.png|bmp|jpg$/)
        if ext.empty?
            super(x,y,"#{fn}0.png")
            @name = fn 
            @max = 0
            c=0
            regexp = Regexp.new("^#{@name}[0-9]+\.png$")
            #classファイル読み込み
            Dir.foreach("image"){|f|
                if f.to_s =~ regexp
                    c+=1
                end
            }
            if c>0
                @max = c-1
            end
            @now = 0
            @flag = true
            @loop = true
            @next = Timer.new(5)
            @next.play
            @anime = @max > 0
            @end =false
            @reverse = false
        else
            super 
        end
    end
    def play
        @flag = true
    end
    def up?
        return @end
    end
    def animation
        if @flag && !$pause
            load_image("#{@name}#{@now}.png")
            if @next.up?
                @next.reset
                if !@reverse 
                    @now +=1
                else
                    @now -=1
                end
                if @reverse
                    if @now <=0
                        if @loop
                            @now = 0
                        else
                            @now = 0
                            @flag = false
                            @end = true
                        end
                    end
                else
                    if @now > @max
                        if @loop
                            @now = 0
                        else
                            @now = 0
                            @flag = false
                            @end = true
                        end
                    end
                end
            end
            @image.set_color_key(SDL::SRCCOLORKEY,@image.get_pixel(0,0))
        end
    end
    def delay(n)
        @next.set(n)
        @next.reset
    end
    def stop 
        @flag = false
    end
    def now
        return @now
    end
    def stop?
        return !@flag
    end
    def move?
        return @flag
    end
    def loop?(f=nil)
        if f!=nil
            @loop = f
        end
        return @loop
    end
    def reverse(n)
        @reverse = n
    end
    def next
        @now +=1
        if @now > @max
            @now = @max
        end
    end
    def prev
        @now -=1
        if @now < 0
            @now = 0
        end
    end
    def at(n)
        @now = n
    end
    attr_reader :w,:h
end

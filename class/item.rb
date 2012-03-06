class Item
    include Obj
    def initialize(x,y,fn="")
        @x = x
        @y = -y
        @v = Vector.new(rand(100),rand(100))
        @speed = 0
        @inv = Timer.new(5)
        @finv = false
        @v.resize(@speed)
        load_image(fn)
        set_layer(0)
        $stage_que.push(self)
    end
    def act
        #if @speed.abs <2
        #@v.resize(1)
        #else
        #@v.resize(@speed)
        #end
        if hit_frame(false)
            @v.reverse!
        end
        if hitTest($my)
            hit
        end
        if !in?
            destroy
        end
    end
    def hit
    end
    def pop
        $items.push(self)
    end
    def destroy
        $items.reject!{|i|eql?(i)}
    end
end
#Sフラッグ(エクステンド)
class SFlag < Item
    def initialize(x,y)
        super(x,y,"sflag.png")
    end
    def hit
        destroy
        $my.get_extend
    end
end
#パワーアップアイテム
class Power < Item
    #打つと色が変化
    def initialize(x,y)
        super(x,y,"power1.png")
        @v = Vector.new(rand(100)-50,-1*rand(100))
        @speed = 1
        @v.resize(@speed)
        @color = 0
        @image.alpha(10)
    end
    def hit
        super
        $my.power(@color)
        destroy
    end
    def act
        super
        load_image("power#{@color+1}.png")
        #下方向へ落下
        @v.y +=0.1
        if @v.length < -10
            @v.resize(-10)
        end
        $bullets.each do |b|
            if hitTest(b)
                @v +=b.v*0.2
                b.destroy
                if !@finv
                    @color +=1
                    if @color>3
                        #destroy
                        @color = 0
                    end
                    @finv = true
                    @inv.play
                end
            end
        end
        #弾の無敵処理 
        if @inv.up?
            @inv.reset
            @inv.stop
            @finv = false
        end
        @speed = @v.length
    end
end

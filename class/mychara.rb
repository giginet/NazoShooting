class Mychara
    include Chara
    def initialize(x="",y="",fn="")
        super
        set_layer(0)
        @image.enable_alpha
        @reload = Timer.new(3)
        @reload.play
        @reload_down = Timer.new(10)
        @reload_down.play
        @hitarea.size(3)
        @speed = 5
        @rspeed = 5
        @score = 0
        #パワーアップ関連
        @score_lv = 1
        @level = 1
        @speed_lv = 1
        @attack_lv = 1
        @hp = 1
        set_speed
    end
    def move
        if !$scene.dead
            act
            @x += @v.x
            @y += @v.y
        end
    end
    def input
        set_speed
        #水平方向
        if $input.left?
            @v.x = -@speed
        elsif $input.right?
            @v.x = @speed
        else
            #慣性移動
            if @v.x.abs > 0.1
                @v.x *=0.5
            else
                @v.x = 0
            end
        end
        #垂直方向
        if $input.up?
            @v.y = -@speed
        elsif $input.down?
            @v.y = @speed
        else
            #慣性移動
            if @v.y.abs > 0.1
                @v.y *=0.5
            else
                @v.y = 0
            end
        end
        #@speed以上なら戻す
        if @v.length > @speed
            @v.resize(@speed)
        end
        #bullet発射
        if $input.shot? && @reload.up?
            @reload.reset
            #normal
            #three_way
            @shot = SE.new("shoot14.wav",8)
            #@shot.set_volume(8)
            @shot.play
            if @level == 1
                my_level1
            elsif @level== 2
                my_level2
            elsif @level== 3
                my_level3
            end
            #circle
        end
        #ドロップショット発射
        if $input.x? && @reload_down.up?
            @reload_down.reset
            b = Updown.new(self,@x,@y)
            b.drop_point(@x,@y-100)
        end
        #低速移動
        if $input.shift?
            @speed = 2
            @hitarea.visible = true
        else
            @speed = @rspeed
            @hitarea.visible = false
        end
    end
    def act
        common
        @attack = 0.5+0.5*@attack_lv
        if !$clear
            hit_frame(true)
        end
        #敵との当たり
        $charas.each do |c|
            if @hitarea.hitTest(c.hitarea) && !c.mychara?
                destroy
            end
        end
    end
    def konami
        @speed_lv = 5
        @attack_lv = 5
        @level = 3
        @hp = 100
        set_speed
    end
    def mychara?
        true
    end
    def destroy
        if !$scene.dead
            $scene.dead = true
            SDL::Mixer.halt_music
            load_image("owata3.png")
        end
    end
    def power(c)
        if c==0  
            #黄
            get_score(200*@score_lv)
            @score_lv+=1
            if @score_lv > 5
                @score_lv = 5
            end
        elsif c==1
            #緑
            if @speed_lv <10 
                @speed_lv +=1
            end
            set_speed
        elsif c==3
            #青
            if @level <3
                @level +=1
            end
        elsif c==2
            #赤
            if @attack_lv < 5
                @attack_lv +=1
            end
        end
        if c!=0
            @score_lv = 1
            get_score(100)
            s = SE.new("power03.wav")
        else
            s= SE.new("fm009.wav")
        end
        s.play
    end
    def set_speed(option=0)
        @rspeed = 3.75+option+(@speed_lv-1)*0.3
    end
    def get_score(score)
        pre = $score
        $score += score
        #二万点でエクステンド
        if (pre/20000).floor != ($score/20000).floor
            get_extend
        end
        if $score > $highscore
            $highscore = $score
        end
    end
    def get_extend
        $extend +=1
        #se = SE.new("cursol32.wav")
        #se.play
    end
end

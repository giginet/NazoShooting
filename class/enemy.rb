module Enemy
    include Chara
    def initialize(x=0,y=0,fn="")
        super(x,y,fn)
        set_skill 
        @tmove = Timer.new
        @boss =false
        @bombtype = :normal
        @tshot = Timer.new
        @speed = 3
        @can_shot = false
        #set_vector
        @tshot.set_random(100)
        @tshot.play
        #行動管理キュー
        @moving = false
        @moveshot = false
        @act_que = Array.new
        @hitarea.size(20)
        @type = :direction
        @frequency = 20
        @dead = false
        set_layer(0)
        @hitarea.set_layer(0)
    end
    def act
        common
        #if @tshot.up?
        #    shot
        #    @tshot.set(@frequency)
        #    @tshot.reset
        #end
        if !@act_que.empty?
            @act_que.first.act
            if @act_que.first.up?
                #行動が終わったらデキュー
                @act_que.shift.deque
            end
        end
        if @moveshot
            shot
        end
        #hit_frame
    end
    #AI系 
    def set_vector
        @tmove.set_random(200)
        @tmove.play
        @v = Vector.new(rand(100)-50,rand(100)-50)
        @v.resize(@speed)
    end
    def toggle_shot(flag=nil)
        if flag.nil?
            @can_shot = !@can_shot
        else
            @can_shot = flag
        end
    end
    def enque(obj)
        @act_que.push(obj)
    end
    def destroy
        @dead = true
        if in_screen? || @boss
            #爆風の生成
            b = Bomb.new(self)
            b.image("bomb")
            #弾の相殺
            $bullets.each do |b| 
                if eql?(b.owner)
                    b.destroy
                end
            end

        end
    end
    #攻撃頻度の設定
    def frq(n)
        @frequency = n
        @tshot.set(n)
        @tshot.reset
    end
    def set_move(x,y,flag=false)
        @can_shot = flag
        a = MoveAct.new(self,x,y,flag)
        @act_que.push(a)
        @moveshot = flag
    end
    def set_shot(limit=1000,type=nil,f=nil)
        a = ShotAct.new(self,limit)
        if !f.nil?
            frq(f)
        end
        if !type.nil?
            set_shot_type(type)
        end
        @act_que.push(a)
    end
    def set_shot_type(t)
        @type = t
    end
    def set_wait(n)
        a = WaitAct.new(self,n)
        @act_que.push(a)
    end
    def shot(type=nil)
        if !type.nil?
            set_shot_type(type)
        end
        if @tshot.up?
            @skills[@type].call
            @tshot.set(@frequency)
            @tshot.reset
            return true
        else
            return false
        end
    end
    def set_speed(n)
        @speed = n
    end
    public :shot
    attr_accessor :moving
    attr_reader :tshot,:bombtype
    attr_writer :can_shot
end
#空中ユニットクラス
class Sky
    include Enemy
    def intialize(x,y,fn)
        super
        set_layer(0)
        @hitarea.set_layer(0)
    end
    def destroy
        super
        $charas.reject!{|b|b.eql?(self)}
    end
end
#各敵
class Zako1 < Sky
    def initialize(x,y)
        super(x,y,"zako")
        @next = Timer.new(5)
        @shot_flag = true
    end
    def act
        super
    end
end
class Zako2 < Sky
    def initialize(x,y)
        super(x,y,"enemy.png")
        @next = Timer.new(5)
        @shot_flag = true
        @score = 200
    end
    def act
        super
    end
end

#
class Faker < Sky
    def initialize(x,y)
        super(x,y,"faker")
        @rotate_timer = Timer.new(50)
        @rotate_timer.play
        @core = true
        @back = false
        @score = 500
        frq(2)
    end
    def act
        super
        if @rotate_timer.up?
            @image.play
            if @core
                @image.reverse(false)
                if @image.now ==4
                    @back = true
                    @core = false
                    @rotate_timer.reset
                end
            else
                @image.reverse(true)
                if @image.now ==0
                    @core = true
                    @rotate_timer.reset
                end
            end
        else
            @image.stop
        end
        #コアが前の時
        if @core && !@image.move? 
            @finv = false
            @back = false
            @front = true
        else
            #コアが前以外の時
            @front = false
            @finv = true 
        end
        #コアが後ろの時
        if !@core && !@image.move?
            shot(:wide)
        end
    end
    def shot(type=:wide)
        if @back && (@moveshot || !@moving)
            super(type)
        end
    end
end
#ボスクラス
class Boss
    include Enemy
    def initialize(x,y,fn)
        super
        @bombtype = :big
        @boss = true
        @moveshot = true
        @hp = 10
        @image.enable_alpha
    end
    def destroy
        super
        $charas.reject!{|b|b.eql?(self)}
        $clear = true
    end
end
class Stage1 < Boss
    def initialize(x,y)
        super(x,y,"boss.png")
        @tshot.play
        @hitarea.size(30)
        @hitarea2 = Hit.new(self,50)
        frq(15)
        @hp = 50
        @hitarea3 = Hit.new(self,50)
        @angle =0
        @can_shot = true
        @next = Timer.new(180)
        @next.play
        @phase = 0
        @score = 5000
        @type = :circle
    end
    def act
        common
        #移動
        if @phase==0
            @v.x = Math.cos(@angle*Math::PI/180)
            @v.y = Math.sin(@angle*Math::PI/180)
            @v.resize(@speed)
            @angle+=2 
        elsif @phase ==1
            @v.resize(0)
        elsif @phase ==2
            c = @next.now
            if c<45
                @v.x = 1
            elsif c<135
                @v.x = -1
            elsif c<180
                @v.x = 1
            end
            @v.resize(@speed)
        elsif @phase ==3
            @v.resize(0)
        end
        #フェイズ移行
        if @next.up?
            @phase = (@phase+1)%4
            frq([15,1,2,5][@phase])
            if @phase==2
                @next.set(180)
            else
                @next.set(156)
            end
            @next.reset
        end
        #攻撃
        if @phase==0
            @type = :circle
        elsif @phase==1
            @type = :star
        elsif @phase==2
            @type = :multiple
        elsif @phase==3
            @type = :summon
        end
        shot
    end
    def hit
        super
    end
end
#陸上ユニットクラス
class Canon
    include Enemy
    def initialize(x,y,fn)
        super
        @type = :upshot
        @can_shot = true
        set_layer(1)
        @hitarea.set_layer(1)
    end
    def shot
        if !@dead
            super(@type)
        end
    end
end
class Canon1 < Canon
    def initialize(x,y)
        super(x,y,"canon.png")
        @score = 200
        set_shot
    end
    def destroy
        super
        load_image("canon_death.png")
        @hitarea.size(0)
        if !in?
            $charas.reject!{|b|b.eql?(self)}
        end
    end
end


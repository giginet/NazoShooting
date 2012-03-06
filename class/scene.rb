class TitleScene
    def initialize
        @title_tx = Text.new("謎シューティング(仮)",40,100,54)
        @start_tx = Text.new("START",225,250)
        @config_tx = Text.new("CONFIG",250,300)
        @exit_tx = Text.new("EXIT",300,350)
        @timer = Timer.new(120)
        @cursol = Cursol.new([[135,233],[165,283],[205,333]])
        @screen_alpha = 0
    end
    def start
        @cursol.reset
        @timer.reset
        @timer.stop
        @screen_alpha = 0
    end
    def act
        if @cursol.enter?
            if @cursol.now==0
                if !@cursol.selected?
                    @cursol.selected = true
                    @timer.play
                    se = SE.new("se_start.aif")
                    se.play
                end
            elsif @cursol.now==1
                return :config
            elsif @cursol.now==2
                $exit = true 
            end
        end
        if @timer.move?
            if @timer.now > 80
                $effect.play
            end
        end
        if @cursol.selected? && @timer.up?
            #return :game
            return :game
        else
            return nil
        end
    end
    def render 
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[0,0,0])
        @cursol.act
        @title_tx.draw
        @start_tx.draw
        @config_tx.draw
        @exit_tx.draw
    end
end
class GameScene
    def initialize
        @score_text = Text.new("",120,10)
        @score_text.color(255,153,51)
        @score_text.enable_shadow
        @extend_text = Text.new("",50,420)
        @extend_text.color(255,153,51)
        @extend_text.enable_shadow
        @score2_text = Text.new("SCORE",50,10)
        @score2_text.color(0,255,255)
        @score2_text.enable_shadow
        @highscore_text = Text.new("",400,10)
        @highscore_text.color(255,153,51)
        @highscore_text.enable_shadow
        @highscore2_text = Text.new("HIGHSCORE",280,10)
        @highscore2_text.color(0,255,255)
        @highscore2_text.enable_shadow
        @stage_number = 1
        $score = 0
        @start_y = 0
        $extend = 2
        @bgs = Array.new
        (0...10).each do |i|
            @bgs.push(Image.new(320,320+i*-640,"bg_stage1.png"))
        end
    end
    attr_accessor :dead,:start_y
    def start
        GC.start
        #bullet管理配列
        $bullets = Array.new
        $charas = Array.new
        $items = Array.new
        #スクロール管理
        $scroll = Scroll.new
        #自機配置
        $stage = Stage.new(@stage_number)
        $my = Mychara.new(320,@start_y-400,"my.png")
        #BGM関連
        @bgm = SDL::Mixer::Music.load("sound/bgm#{@stage_number}.aif")
        @bgmtimer = Timer.new(60)
        @bossbgm = false
        SDL::Mixer.play_music(@bgm,-1)
        SDL::Mixer.set_volume_music(32)
        @stage_logo = Logo.new(@stage_number)
        $scroll.y = @start_y
        #デバッグ用キュー
        $debugs = Array.new
        @texts = Array.new
        #死亡処理関係
        @dead = false
        @dead_timer = Timer.new(150)
        @test = Text.new("",200,100)
        #ポーズ
        $pause = false
        @pause_tx = Text.new("PAUSE",263,135,36)
        @pause_tx.enable_shadow
        @play_tx = Text.new("続ける",275,175)
        @yes_tx = Text.new("はい",275,175)
        @return_tx = Text.new("やめる",275,225)
        @no_tx = Text.new("いいえ",275,225)
        @message_tx = Text.new("タイトル画面へ戻りますか？",145,135)
        @message_tx.enable_shadow
        @cursol = Cursol.new([[190,160],[190,210]])
        @menu = 0
        $clear = false
        @tclear = Timer.new(300)
        $input.lock = false
    end
    def act
        #キャラの移動
        if !$pause 
            #ステージロゴ
            @stage_logo.act
            $my.input
            $scroll.scroll
            $charas.reverse.each do |c|
                c.move
            end
            $bullets.each do |b|
                b.move
            end
            $my.move 
            $items.each do |i|
                i.move
            end
            $stage.pop

            #死亡処理
            result = nil
            if @dead
                @dead_timer.play
                $input.lock =true
                $scroll.stop
                #$scroll.stop
                if @dead_timer.up?
                    $input.lock = false
                    if $extend == 0
                        $extend = 2
                        $score = 0
                        @start_y = 0
                        result = :over
                    else
                        @start_y = $stage.get_revive
                        $extend -=1
                        result = :game
                    end
                elsif @dead_timer.now == 30
                    owata = SE.new("owata.wav",64)
                    owata.play
                    $my.hitarea.size(0)
                    $my.start_inv
                    8.times{|i|
                        dx = 24*Math.cos(i*90*Math::PI/180)
                        dy = 24*Math.sin(i*90*Math::PI/180)
                        x = $my.x + dx
                        y = $my.y + dy
                        a = Bullet.new($my,x,y)
                        a.image("owata")
                        a.v = Vector.new(dx,dy)
                        a.v.resize(10)
                        a.through(true)
                        a.image("owata")
                    }
                elsif @dead_timer.now == 31
                    4.times{|i|
                        dx = 24*Math.cos((45+i*90)*Math::PI/180)
                        dy = 24*Math.sin((45+i*90)*Math::PI/180)
                        x = $my.x + dx
                        y = $my.y + dy
                        a = Bullet.new($my,x,y)
                        a.image("owata")
                        a.v = Vector.new(dx,dy)
                        a.v.resize(8)
                        a.through(true)
                        a.image("owata")
                    }
                end
            end
            #音楽
            if $scroll.y > STAGE_Y - 750
                if @bgmtimer.now ==0
                    SDL::Mixer.fade_out_music(2000)
                    @bgmtimer.play
                end
                if @bgmtimer.up? && !@bossbgm
                    @bgm = SDL::Mixer::Music.load("sound/boss.aif")
                    SDL::Mixer.play_music(@bgm,-1)
                    @bgmtimer.stop
                    @bossbgm = true
                end
            end
        else
            if $input.a?
                $my.konami
            end
            #ポーズ中メニュー
        end
        #pause
        if $input.pause?
            pause =SE.new("power31.wav")
            GC.start
            pause.play
            if $pause 
                if @menu==0
                    if @cursol.now ==0
                        $pause = false
                        SDL::Mixer.set_volume_music(16)
                    else
                        @menu = 1
                    end
                else
                    if @cursol.now == 0
                        SDL::Mixer.fade_out_music(100)
                       # $pause = false
                        result = :title
                    else
                        @menu = 0
                    end
                end
            else
                $pause = true
                SDL::Mixer.set_volume_music(8)
            end
        end
        #ボス撃破後のイベント
        if $clear && !@dead
            SDL::Mixer.fade_out_music(4000)
            if !@tclear.move? 
                @tclear.play
                $input.lock =true
            end
            if @tclear.now == 120
                a = SE.new("warp01.wav")
                a.play
                $my.disable_hit
            elsif @tclear.up?
                @stage_number +=1
                result = :game
            elsif @tclear.now > 180
                $effect.play(5)
            elsif @tclear.now > 150
                $my.speed = 0
                $my.v.y = 0
            elsif @tclear.now > 120
                if $my.y+$scroll.y > -200
                    $my.v.y = -20
                    $my.speed = 20
                else
                    $my.v.y = 0
                    $my.speed = 0
                end
            end
        end
        return result
    end
    def clear
        @clear = true
    end
    def render
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[255,255,255])
        @bgs.each do |b|
            b.render
        end
        $charas.sort!{|a,b|a.layer<=>b.layer}
        $charas.reverse.each do |c|
            c.render
        end
        $bullets.each do |b|
            b.render
        end
        $my.render 
        $items.each do |i|
            i.render
        end
        @stage_logo.render
        @score_text.draw($score)
        @score2_text.draw
        @highscore_text.draw($highscore)
        @highscore2_text.draw
        @extend_text.draw($extend)
        #ポーズ限定
        if $pause
            @cursol.act
            if @menu==0
                @pause_tx.draw
                @play_tx.draw
                @return_tx.draw
            else
                @message_tx.draw
                @yes_tx.draw
                @no_tx.draw
            end
        end
        $frames+=1
    end
end
class PauseScene
    def initialize
    end
    def act
    end
    def render
    end
end
class OverScene
    def initialize
        @over_tx = Text.new("GAME OVER",200,200,54)
        @over_tx.color(255,255,255)
        @retry_tx = Text.new("リトライ",275,253)
        @title_tx = Text.new("タイトル",275,300)
        @cursol = Cursol.new([[205,237],[205,285]])
        @retry_tx.color(255,255,255)
        @title_tx.color(255,255,255)
    end
    def start
        $input.lock = false
        @bgm = SDL::Mixer::Music.load("sound/gameover.aif")
        SDL::Mixer.play_music(@bgm,1)
        file = File.open("score.dat","w")
        file.puts $highscore
        file.close
    end
    def act
        if $input.pause?
            if @cursol.now == 0
                #$effect.play
                return :game
            else
                #$effect.play
                return :title
            end
        else
            return nil
        end
    end
    def render
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[0,0,0])
        @over_tx.draw
        @retry_tx.draw
        @title_tx.draw
        @cursol.act
    end
end
class ConfigScene
    def initialize
        @config_tx = Text.new("コンフィグ",50,50)
    end
    def start
    end
    def act
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[255,255,255])
    end
    def render
        @config_tx.draw
    end
end


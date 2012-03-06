require 'sdl'


require "lib/fpstimer"
#classファイル読み込み
Dir.foreach("class"){|f|
    if f.to_s =~ /\.rb$/
        require "class/#{f.to_s}"
    end
}

def atr(angle)
    return angle*Math::PI/180
end
class Array
    def choice
        at( rand( size ) )
    end
end
class Hash
    def choice
        keys.choice
    end
end
#定数
SCREEN_W = 640
SCREEN_H = 480
STAGE_X = 640
STAGE_Y = 5600
HOLIZON = 400
RATE = 30
#joy = SDL::Joystick.open(0)
$timers = Array.new
$frames = 0
####ハイスコアのロード
if File.exist?("score.dat")
    File.open("score.dat").each do |l|
      $highscore = l.chomp
    end
else
    $highscore = 5000
    file = File.open("score.dat","w")
    file.puts $highscore
    file.close
end
$highscore = $highscore.to_i
#Windowまわり
SDL.init(SDL::INIT_EVERYTHING)
SDL::WM.setCaption("STG(仮)","image/bomb.bmp")
$screen = SDL.set_video_mode(SCREEN_W,SCREEN_H,16,SDL::SWSURFACE)
SDL::Mixer.open
$pause = false
$effect = Fade.new
$exit = false
#FPS
$input = Input.new
timer = FPSTimerLight.new(fps=RATE)
timer.reset
#メインループ
Scenes = {:title=>TitleScene.new,:game=>GameScene.new,:over=>OverScene.new,:config=>ConfigScene.new}
$scene = Scenes[:title]
loop do
    $input.poll
    if !$pause 
        $timers.each do |t|
            t.tick
        end
    end
    #シーケンス遷移
    next_scene = $scene.act
    if next_scene
        $scene = Scenes[next_scene]
        GC.start
        $scene.start
        if $effect.now != 0
            $effect.play(50,true)
        end
    end
    $scene.render
    $effect.render
    if $exit 
        break
    end
    timer.wait_frame do
        $screen.update_rect(0,0,0,0)
    end
end

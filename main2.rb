require "sdl"
require "lib/fpstimer"
require "lib/input"

SCREEN_W = 640
SCREEN_H = 480
HOLIZON  = 400

def load_image(fname)
  image = SDL::Surface.load(fname)
  image.set_color_key(SDL::SRCCOLORKEY, [255, 255, 255])

  image
end
require "player"
require "items"

class Input
  define_key SDL::Key::ESCAPE, :exit
  define_key SDL::Key::LEFT, :left
  define_key SDL::Key::RIGHT, :right
end

SDL.init(SDL::INIT_EVERYTHING)
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)

player = Player.new(240)
items = Items.new

input = Input.new        
timer = FPSTimerLight.new
timer.reset
loop do  
  input.poll            
  break if input.exit

  player.act(input)            
  is_crashed = items.act(player)    # 爆弾に当たったか？
  break if is_crashed               # 当たったらゲーム終了

  screen.fill_rect(0, 0,       SCREEN_W, HOLIZON,          [128, 255, 255])
  screen.fill_rect(0, HOLIZON, SCREEN_W, SCREEN_H-HOLIZON, [0, 128, 0])
  player.render(screen)  
  items.render(screen) 
  timer.wait_frame do
    screen.update_rect(0, 0, 0, 0)
  end
end
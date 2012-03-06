class Player
  def initialize(x)
    @image = load_image("image/nos_front.png")
    @x = x
    @y = HOLIZON - @image.h
  end
  attr_reader :x, :y

  def center
    cx = @x + (@image.w / 2)
    cy = @y + (@image.h / 2)

    [cx, cy]
  end

  def act(input)
    @x -= 8 if input.left
    @x += 8 if input.right
    @x = 0 if @x < 0
    @x = SCREEN_W-@image.w if @x >= SCREEN_W-@image.w
  end

  def render(screen)
    screen.put(@image, @x, @y)
  end
end
class Item
  def initialize(x, y, v)
    @x, @y, @v = x, y, v
    @is_dead = false
  end
  attr_reader :v, :image
  attr_accessor :x, :y, :is_dead

  # 2 点間の距離の計算
  def distance(x1, y1, x2, y2)
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)  # n**2 は 「n の 2 乗」(=n*n)
  end
end

class Apple < Item
  def initialize(x, y, v)
    super
    @image = load_image("image/ringo.bmp")
  end

  # リンゴの当たり判定
  def collides?(player)
    px, py = player.center
    distance(@x+@image.w/2, @y+@image.h/2, px, py) < 56
  end
end

class Bomb < Item
  def initialize(x, y, v)
    super
    @image = load_image("image/bomb.bmp")
  end

  # 爆弾の当たり判定
  def collides?(player)
    px, py = player.center
    distance(@x+@image.w/2, @y+@image.h/2, px, py) < 42
  end
end

class Items

  def initialize
    @items = []
  end

  def act(player)
    crash = false

    @items.each do |item|
      item.y += item.v
      item.is_dead = true if item.y > SCREEN_H
    end
      
    # 当たり判定を行う
    @items.each do |item|
      case item
      when Apple
        item.is_dead = true if item.collides?(player)
      when Bomb
        crash = true if item.collides?(player)
      end
    end

    @items.reject!{|item| item.is_dead}

    while @items.size < 5
      newx = rand(SCREEN_W) 
      newv = rand(9) + 4
      if rand(100) < 60
	@items << Bomb.new(newx, 0, newv)
      else
        @items << Apple.new(newx, 0, newv)
      end
    end

    # 爆弾に当たったかどうかを返す
    crash
  end

  def render(screen)
    @items.each do |item|
      screen.put(item.image, item.x, item.y)
    end
  end
end
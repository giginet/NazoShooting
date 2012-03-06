class SE
  def initialize(fn,v=16)
    @sound = SDL::Mixer::Wave.load("sound/#{fn}")
    @volume = v
    @chanel = -1
    SDL::Mixer.set_volume(-1, @volume)
  end
  def play
    begin
      @channel = SDL::Mixer.play_channel(-1,@sound,0)
      set_channel(16)
    rescue
    end
  end
  def set_volume(v)
      SDL::Mixer.set_volume(@channel, v)
  end
end

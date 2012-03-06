class Input
    def initialize
        @@press_z = false
        @@press_pause = false
        @lock = false
        if joy? 
            @joy = SDL::Joystick.open(0)
            SDL::Joystick.poll = true
        end
    end
    def poll
        SDL::Key.scan
        SDL::Event2.poll
        SDL::Joystick.update_all
        if !z?
            @@press_z = false 
        end
        if !SDL::Key.press?(SDL::Key::RETURN) && !joy_key?(9) && @@press_pause
            @@press_pause =false
        end
    end
    def joy?
        #return SDL::Joystick.num > 0
        return false
    end
    def joy_key?(k)
        if joy? 
            if k > @joy.num_buttons
              k = 0
            end
            return @joy.button(k)
        else
            return false
        end
    end
    def hat(key)
        hash = Hash.new
        hash.default = false
        if joy?
            case @joy.hat(0)
            when SDL::Joystick::HAT_CENTERED
            when SDL::Joystick::HAT_UP
                hash[:up] = true
            when SDL::Joystick::HAT_RIGHT
                hash[:right] = true
            when SDL::Joystick::HAT_DOWN
                hash[:down] = true
            when SDL::Joystick::HAT_LEFT
                hash[:left] = true
            when SDL::Joystick::HAT_RIGHTUP
                hash[:up] = true
                hash[:right] = true
            when SDL::Joystick::HAT_RIGHTDOWN
                hash[:right] = true
                hash[:down] = true
            when SDL::Joystick::HAT_LEFTUP
                hash[:up] = true
                hash[:left] = true
            when SDL::Joystick::HAT_LEFTDOWN
                hash[:left] = true
                hash[:down] = true
            end
            return hash[key]
        else
            return false
        end
    end
    def right?
        return (SDL::Key.press?(SDL::Key::RIGHT) || hat(:right)) && !@lock
    end
    def left?
        return (SDL::Key.press?(SDL::Key::LEFT) || hat(:left)) && !@lock
    end
    def up?
        return (SDL::Key.press?(SDL::Key::UP) || hat(:up))  && !@lock
    end
    def down?
        return (SDL::Key.press?(SDL::Key::DOWN) || hat(:down)) && !@lock
    end
    def z?
        return (SDL::Key.press?(SDL::Key::Z) || joy_key?(1)) && !@lock
    end
    def enter?
        return (SDL::Key.press?(SDL::Key::RETURN) || joy_key?(9)) && !@lock &&!@@press_pause
    end
    def r?
        return SDL::Key.press?(SDL::Key::R) && !@lock
    end
    def t?
        return SDL::Key.press?(SDL::Key::T) && !@lock
    end
    def x?
        return (SDL::Key.press?(SDL::Key::X) || joy_key?(2)) && !@lock
    end
    def b?
        return SDL::Key.press?(SDL::Key::B) && !@lock
    end
    def a?
        return SDL::Key.press?(SDL::Key::A) && !@lock
    end
    def pause?
        if (SDL::Key.press?(SDL::Key::RETURN) || joy_key?(9)) && !@@press_pause
            @@press_pause = true
            return true
        else
            return false
        end
    end
    def shot?
        #if z? && !@@press_z 
        #  @@press_z = true
        #  return true
        #else
        #  return false
        #end
        z?
    end
    def shift? 
        return SDL::Key.press?(SDL::Key::LSHIFT) || joy_key?(6)
    end
    def debug
        if SDL::Joystick.num > 0 
            #return @joy.num_hats
            return joy_key?(9)
        end
    end
    attr_accessor :lock
end

class Scroll
    def initialize 
        @x = 0
        @y = 0
        @speed = 1.5
        @flag = true
        #バックグラウンドの描画
    end
    #縦方向に強制スクロール
    def scroll
        if @flag
            if @y<STAGE_Y-SCREEN_H
                @y+=@speed
                if !$input.down?
                    $my.y -=@speed
                end
            end
        end
    end
    def play
        @flag = true
    end
    def stop
        @flag = false
    end
    attr_accessor :x,:y
end

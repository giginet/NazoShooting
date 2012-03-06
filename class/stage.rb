class Stage
    def initialize(n)
        @no = n
        #ステージデータを読み込む
        #キューに配置予定のオブジェクトをまとめる
        $stage_que = Array.new
        @revive_points = Array.new
        set_revive
        #座標順にソート
        load("data/stage#{@no}.rb")
        sort
    end
    def sort
        $stage_que.sort!{|a,b|b.y<=>a.y} 
    end
    def pop
        #スクロール座標が配置位置を過ぎたとき、オブジェクトをデキューしてnew
        if $stage_que.empty? 
            c = false
        else
            c =$stage_que.first.past? 
        end
        while c 
            p = $stage_que.shift
            p.pop
            if $stage_que.empty? 
                c = false
            else
                c =$stage_que.first.past? 
            end
        end 
    end
    def auto_pop
        if $charas.length < 7 && $scroll.y < 4000
            if rand(80)==0
                if rand(2) ==0
                    Sky.new(rand(SCREEN_W-$scroll.x),480-$scroll.y,"enemy.png")
                else
                    Canon.new(rand(SCREEN_W-$scroll.x),480-$scroll.y,"canon.png")
                end
            end
        end
        if rand(200)==0
            if rand(20) ==0
                SFlag.new(rand(SCREEN_W-$scroll.x),$scroll.y)
            else
                Power.new(rand(SCREEN_W-$scroll.x),$scroll.y)
            end
        end
    end
    #死亡後の復帰地点を返す
    def get_revive
        pre = 0
        @revive_points.each do |p|
            if p < $scroll.y
                pre = p
            else
                break
            end
        end
        return pre
    end
    def set_revive
        @revive_points = [0,950,2250,3350,4100]
    end
end

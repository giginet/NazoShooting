
f = Zako1.new(600,100)

f.set_move(-100,0,true)
f = Zako1.new(600,150)
f.set_move(-100,50,true)
f = Zako1.new(40,150)
f.set_move(740,50,true)
f = Zako1.new(40,200)
f.set_move(740,100,true)

f = Power.new(rand(SCREEN_W),300)

f = Power.new(rand(SCREEN_W),500)

f = Canon1.new(240,160)
f = Canon1.new(400,240)

f = Power.new(480,550)
f = Canon1.new(200,540)
f = Canon1.new(240,540)
f = Canon1.new(200,570)
f = Canon1.new(240,570)

def tank(y)
    f = Tank.new(310,y)
    (1..6).each do |i|
        f.set_move(310,y-150*i)
        f.set_shot(50,:upshot)
    end
    f.set_move(310,y-500)
end
tank(570)

f = Meteor.new(500,1100)
f = Meteor.new(640,1150)
f = Meteor.new(600,1200)
f = Meteor.new(600,1100)
f = Meteor.new(450,1200)



Power.new(rand(SCREEN_W-$scroll.x),540)
Power.new(rand(SCREEN_W-$scroll.x),550)
Power.new(rand(SCREEN_W-$scroll.x),560)
f = Zako1.new(100,800)
f.set_move(320,750,false)
f.set_shot(10,:circle,50)
f.set_move(740,300)
f = Zako1.new(80,850)
f.set_move(320,800,false)
f.set_shot(10,:circle,50)
f.set_move(740,350)

f = Faker.new(640,1000)
f.set_move(320,950,true)
f.set_shot(100,:wide,5)

Power.new(rand(SCREEN_W-$scroll.x),800)
Power.new(rand(SCREEN_W-$scroll.x),850)
Power.new(rand(SCREEN_W-$scroll.x),900)

f = Canon1.new(100,1130)
f = Canon1.new(400,860)

#美しいフォーメーション
def line(x,y,a)
    f = Zako1.new(x,y)
    f.set_move(x,y-150)
    f.set_shot_type(:normal)
    f.set_move(a,y-150,true)
end
line(300,1300,-100)
line(300,1330,-100)
line(300,1360,-100)
line(300,1390,-100)
line(300,1420,-100)
line(300,1450,-100)
line(340,1300,640)
line(340,1330,700)
line(340,1360,700)
line(340,1390,700)
line(340,1420,700)
line(340,1450,700)
tank(870)
#f = Zako1.new(320,1950)
#f.set_move(320,1900,false)
#f.set_shot(3,:circle,10)
#f.set_move(320,2000)
#f.set_shot(100,:circle,50)

Power.new(rand(SCREEN_W-$scroll.x),1500)
Power.new(rand(SCREEN_W-$scroll.x),1550)
Power.new(rand(SCREEN_W-$scroll.x),1600)
Power.new(rand(SCREEN_W-$scroll.x),1650)
Power.new(rand(SCREEN_W-$scroll.x),1700)
Power.new(rand(SCREEN_W-$scroll.x),1750)

tank(1500)
f = Canon1.new(50,1550)
f = Canon1.new(100,1550)
f = Canon1.new(500,1800)

tank(1600)
f = Zako2.new(640,1700)
f.set_move(-100,1400,true)
f = Zako2.new(640,1740)
f.set_move(-100,1440,true)
f = Zako2.new(640,1780)
f.set_move(-100,1480,true)
f = Zako2.new(640,1820)
f.set_move(-100,1520,true)


f = Canon1.new(400,1900)
f = Canon1.new(400,1940)
f = Canon1.new(400,1980)

tank(2000)
Power.new(300,2000)
Power.new(500,1980)
Power.new(400,2000)
Power.new(400,2100)
Power.new(400,2050)

f = Zako1.new(0,2300)
f.set_move(200,2250)
f.set_shot(1,:circle,20)
f.set_move(740,2500)

tank(2700)
#横に突っ込む敵
def horizonal(y,wait=30)
    f = Zako1.new(640,y)
    f.set_wait(wait)
    f.set_speed(10)
    f.set_shot_type(:normal)
    f.frq(8)
    f.set_move(200,y-550,true)
end
#縦に突っ込む敵
def virtical(x,y)
    f = Zako1.new(x,y)
    f.set_speed(20)
    f.set_move(x,y-600)
end
#縦に突っ込む敵
def virtical2(x,y)
    f = Zako1.new(x,y)
    f.set_speed(20)
    f.frq(10)
    f.set_move(x,y-600,false)
end

virtical2(130,2500)
virtical2(130,2520)
virtical2(130,2540)
virtical2(130,2560)
virtical2(130,2580)
virtical2(130,2600)
virtical2(130,2620)
virtical2(130,2640)
virtical2(130,2660)
virtical2(530,2500)
virtical2(530,2520)
virtical2(530,2540)
virtical2(530,2560)
virtical2(530,2580)
virtical2(530,2600)
virtical2(530,2620)
virtical2(530,2640)
virtical2(530,2660)


f = Zako1.new(640,2500)
f.set_move(400,2350)
f.set_shot(1,:circle,20)
f.set_move(320,2900)
f = Zako1.new(0,2550)
f.set_move(200,2400)
f.set_shot(1,:circle,20)
f.set_move(320,2950)

f = Canon1.new(150,2600)
f = Canon1.new(200,2650)
f = Canon1.new(250,2600)
f = Canon1.new(200,2550)


f = Zako2.new(200,2850)
f.set_shot_type(:multiple)
f.frq(5)
f.set_move(200,2500,true)

f = Zako2.new(200,2900)
f.set_shot_type(:multiple)
f.frq(5)
f.set_move(200,2500,true)

f = Zako2.new(200,2950)
f.set_shot_type(:multiple)
f.frq(5)
f.set_move(200,2500,true)

f = Zako1.new(600,2940)
f.set_shot_type(:homing)
f.frq(15)
f.set_move(400,2500,true)


f = Canon1.new(100,2850)
f = Canon1.new(400,2800)
f = Canon1.new(600,3100)

Power.new(rand(SCREEN_W-$scroll.x),3000)
Power.new(rand(SCREEN_W-$scroll.x),3050)
Power.new(rand(SCREEN_W-$scroll.x),3100)
f = Faker.new(320,3200)
f.set_move(320,3150)
f.set_shot(60,:wide,3)
f.set_move(320,3600)


#virtical(320,3450)
virtical(150,3540)
virtical(240,3550)
virtical(400,3600)
virtical(320,3600)
virtical(200,3600)
virtical(500,3600)
virtical(20,3600)
virtical(600,3610)
virtical(50,3480)
virtical(320,3650)
virtical(400,3600)
virtical(500,3620)
Power.new(rand(SCREEN_W-$scroll.x),150)
Stage1.new(320,STAGE_Y-550)

f = Cross.new(200,3700)
f.set_move(50,3620)
f.set_shot(10000,:cross,4)

f = Cross.new(310,3900)
f.set_move(550,3850)
f.set_shot(10000,:cross,4)

f = Faker.new(0,4250)
f.set_move(320,4200)
f.set_shot(10000,:wide,4)


f = Meteor.new(530,4300)
f = Meteor.new(560,4250)
f = Meteor.new(450,4300)
f = Meteor.new(50,4550)
f = Meteor.new(640,4400)
f = Meteor.new(450,4340)
f = Meteor.new(510,4270)
f = Meteor.new(200,4450)
f = Meteor.new(200,4320)
f = Meteor.new(100,4350)
f = Meteor.new(10,4850)
f = Meteor.new(660,4650)
f = Meteor.new(531,4520)
f = Meteor.new(300,4900)
f = Meteor.new(300,4350)
f = Meteor.new(600,4600)
f = Meteor.new(300,4200)
f = Meteor.new(100,4500)
f = Meteor.new(500,4200)
tank(4200)

f = Canon1.new(251,3740)
f = Canon1.new(512,3320)
f = Canon1.new(220,3550)
f = Canon1.new(310,3650)

f = Canon1.new(310,4290)
tank(4700)
tank(4400)
#####アイテムゾーン
(0...40).to_a.each do |i| 
    f = Power.new(rand(SCREEN_W),4800-rand(200))
end

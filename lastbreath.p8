pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	menu_init()
	border_init()
	stars_init()
	p_init()
	lasers_init()
	asteroids_init()
	
	asttimer=0
	astmax=100
	astmin=20
	score=0
	cartdata(0)
	high_score=dget(0) or 0
	play=false
end

function _update()
	border_update()
	stars_update()
	asteroids_update()
	if play then
		if (asttimer<=0) then
			asteroid_spawn()
			asttimer=flr(rndb(astmin,astmax))
		end
		asttimer-=1
		p_update()
	else
		menu_update()
	end
	lasers_update()

	
	for l in all (lasers) do
		for a in all (asteroids) do
			if collide(a,l) then
				del(lasers,l)
				del(asteroids,a)
				sfx(2)
				if (play) score+=5
			end
		end
	end
	
	for a in all (asteroids) do
		if p_collide(a) then
			sfx(0)
			del(asteroids,a)
			if score > high_score then
				high_score=score
				dset(0,high_score)
			end
			play=false
		end
	end
	
end

function _draw()
	cls()
	stars_draw()
	border_draw()
	asteroids_draw()
	if (play) then
	 p_draw()
	else
		menu_draw()
	end
	lasers_draw()
	print(score,8,12,2)
end

function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end

function collide(a,b)
 return a.x<b.x+b.width and
 	a.x+a.width>b.x and
 	a.y<b.y+b.height and
 	a.y+a.height>b.y
end
-->8
function p_init()
	p={}
	p.x=56
	p.y=56
	p.width=16
	p.height=16
	p.dx=0
	p.dy=0
	p.g=0.025
	p.s=1
	p.fs=33
	p.fy=16
	p.fxl=4
	p.fxr=10
	p.ly=4
	p.llx=14
	p.lrx=0
	p.lcd=0
	p.rcd=0
	p.cd=6
end

function p_update()
	p.dy+=p.g
	if (p.lcd>0) p.lcd-=1
	if (p.rcd>0) p.rcd-=1
	
	p_inputs()
	p_borders()
	
	p.x+=p.dx
	p.y+=p.dy
end

function p_draw()
	spr(p.s,p.x,p.y,2,2)
	if (btn(0)) spr(p.fs,p.x+p.fxl,p.y+p.fy)
	if (btn(1)) spr(p.fs,p.x+p.fxr,p.y+p.fy)
end

function p_fire(side)
	local x,y
	sfx(1)
	y=p.y+p.ly
	if side==0 then
		x=p.x+p.lrx
	else
		x=p.x+p.llx
	end
	laser_init(x,y)
end

function p_inputs()
 if (btnp(🅾️) and p.lcd == 0) then
  p_fire(0)
  p.lcd = p.cd
 end
 if (btnp(❎) and p.rcd == 0) then
  p_fire(1)
  p.rcd = p.cd
 end

 if btn(0) then
  p.dy -= p.g * 1.5
  p.dx -= p.g * 0.5
  if stat(51) == -1 then
   sfx(3, 1)
  end
 end
 if not btn(0) then
  sfx(-1, 1)
 end

 if btn(1) then
  p.dy -= p.g * 1.5
  p.dx += p.g * 0.5
  if stat(52) == -1 then
   sfx(4, 2)
  end
 end
 if not btn(1) then
  sfx(-1, 2)
 end

 if not btn(0) and p.dx < 0 then
  p.dx += p.g * 0.2
 end
 if not btn(1) and p.dx > 0 then
  p.dx -= p.g * 0.2
 end
end

function p_borders()
	if (p.y<14) p.dy=1
	if (p.y>96) p.dy=-1
	if (p.x<14) p.dx=1
	if (p.x>100) p.dx=-1
end

function p_collide(other)
	local temp={}
	temp.x=p.x+2
	temp.y=p.y+2
	temp.width=p.width-4
	temp.height=p.height-4
	if (not play) return false
	return collide(temp,other)
end
-->8
function stars_init()
	sstars={}
	numsstars=40
	for i=1,numsstars do
		local star={}
		star.x=flr(rnd(127))
		star.y=flr(rnd(127))
		star.c=rndb(5,7)
		add(sstars,star)
	end
	
	bstars={}
	numbstars=30
	for i=1,numbstars do
		local star={}
		star.x=flr(rnd(127))
		star.y=flr(rnd(127))
		star.c=rndb(9,10)
		star.maxtime=flr(rndb(60,300))
		star.curtime=flr(rndb(1,star.maxtime))
		star.on = rnd(1) < 0.5
		add(bstars,star)
	end
end

function stars_update()
	for i=1,numsstars do
		local star=sstars[i]
		star.y+=1
		if (star.y==128) star.y=0
	end
	
	for i=1,numbstars do
		local star=bstars[i]
		star.curtime-=1
		if star.curtime<=0 then
			star.on=not star.on
			star.curtime=star.maxtime
		end
	end
end

function stars_draw()
	for i=1,numsstars do
		local star=sstars[i]
		pset(star.x,star.y,star.c)
	end
	
	for i=1,numbstars do
		local star=bstars[i]
		if star.on then
			pset(star.x,star.y,star.c)
		end
	end
end
-->8
function lasers_init()
	lasers={}
	lasspr=3
	lasspd=3
end

function laser_init(x,y)
	local laser={}
	laser.x=x
	laser.y=y
	laser.width=2
	laser.height=6
	add(lasers,laser)
end

function lasers_update()
	for l in all (lasers) do
		l.y-=lasspd
		if (l.y<-5) del(lasers,l)
	end
end

function lasers_draw()
	for l in all (lasers) do
		spr(lasspr,flr(l.x),flr(l.y))
	end
end
-->8
function border_init()
	local offset=10
	local length=10
	
	local col=1
	border={}
	local x=3
	local y=3
	local mag=-1
	for i=3,123 do
		local py=y+offset
		point_init(i,py,col)
		offset+=mag
		if (offset>=length) do
			offset=length
			mag=-1
		end
		if (offset==0) mag=1
		col+=1
		if (col>15) col=1
	end
	
	offset=1
	mag=1
	x=123
	for i=14,123 do
		local px=x-offset
		point_init(px,i,col)
		offset+=mag
		if (offset>=length) do
			offset=length
			mag=-1
		end
		if (offset==0) mag=1
		col+=1
		if (col>15) col=1
	end
	
	y=123
	offset=1
	mag=1
	for i=112,3,-1 do
		local py=y-offset
		point_init(i,py,col)
		offset+=mag
		if (offset>=length) do
			offset=length
			mag=-1
		end
		if (offset<=0) do
		offset=0
		mag=1
		end
		col+=1
		if (col>15) col=1
	end
	
	offset=8
	mag=-1
	x=10
	for i=112,15,-1 do
		local px=x-offset
		point_init(px,i,col)
		offset+=mag
		if (offset>=length) do
			offset=length
			mag=-1
		end
		if (offset==0) mag=1
		col+=1
		if (col>15) col=1
	end
	point_init(2,14,col)
	
end

function border_update()
	temp=border[1].col
	for i=1,#border-1 do
		border[i].col=border[i+1].col
	end
	border[#border].col=temp
end

function border_draw()
	for p in all (border) do
		pset(p.x,p.y,p.col)
	end
end

function point_init(x,y,col)
	local point={}
	point.x=x
	point.y=y
	point.col=col
	add(border,point)
end
-->8
function asteroids_init()
	astinfo={}
	astinfo.speedmin=0.2
	astinfo.speedmax=1
	astinfo.spr=5
	asteroids={}
end

function asteroids_update()
	for a in all (asteroids) do
		a.x+=a.dx
		a.y+=a.dy
		if (a.dx > 0 and a.x >= a.targetx) or (a.dx < 0 and a.x <= a.targetx) then
			del(asteroids,a)
			score+=1
		end
	end
end

function asteroids_draw()
	for a in all (asteroids) do
		spr(astinfo.spr,flr(a.x),flr(a.y))
	end
end

function asteroid_spawn()
	local a={}
	if rnd(1)<0.5 then
		a.x=-8
		a.dir=-1
		a.targetx=136
	else
		a.x=136
		a.dir=1
		a.targetx=-8
	end
	a.y=flr(rndb(0,120))
	a.targety=
		flr(rndb(0,120))
	a.spd=
		rndb(
			astinfo.speedmin,
			astinfo.speedmax)
	
	local dx=a.targetx-a.x
	local dy=a.targety-a.y
	local distance=sqrt(
		(dx^2)+(dy^2))
	dx/=distance
	dy/=distance
	
	a.dx=dx*a.spd
	a.dy=dy*a.spd
	
	a.width=8
	a.height=8
	
	add(asteroids,a)
end
-->8
function menu_init()
	menu={
		items={"start","quit"},
		selected=1
	}
end

function menu_update()
	if btnp(2) then
		menu.selected-=1
		if (menu.selected<1) menu.selected=#menu.items
	end
	if btnp(3) then
		menu.selected+=1
		if (menu.selected>#menu.items) menu.selected=1
	end
	if btnp(4) then
		if (menu.selected==1) then
		 play=true
		 score=0
		elseif (menu.selected==2) then
			shutdown()
		end
	end
end

function menu_draw()
	print("last breath",42,20,7)
	print("high score:"..high_score,40,30,7)
	
	for i=1,#menu.items do
		local color=6
		if i==menu.selected then
			color=10
			print(">",30,40+i*10,10)
		end
		print(menu.items[i],40,40+i*10,color)
	end
end
__gfx__
000000000000000660000000ee000000000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000006666000000ee000000000000000044444000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000066666600000ee000000000000000044d44000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000065555600000ee00000000000000044d444400000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000655f5600000ee0000000000000044d4444400000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000065555600000ee000000000000004444464400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006d66d60000000000000000000000444644000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006d66d60000000000000000000000044440000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066d66d66000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006d66d66d66d60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000776d66d66d66d67700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000776d66d66d66d67700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000776d66d66d66d67700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006d66d66d66d60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00090000324502b450224501b45015450104500d4500b4500a4500845007450064500545004450024500245002450024500000000000000000000000000000000000000000000000000000000000000000000000
000200000000026750207501c750197501675013750107500e7500d75000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000036610316102e61029610246101f6101b610176101561012610106100d6100a61009610086100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0032000c17610206102461028610296102a6102861026610236101e61019610166101660016600146001460000000000000000000000000000000000000000000000000000000000000000000000000000000000
0032000e246101f6101b6201861016610156101461015610176101a6101e610216102261023610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

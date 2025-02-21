pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	border_init()
	stars_init()
	p_init()
	lasers_init()
	asteroids_init()
	
	asttimer=0
	astmaxtimer=60
end

function _update()
	border_update()
	stars_update()
	asteroids_update()
	if (asttimer<=0) then
		asteroid_spawn()
		asttimer=astmaxtimer
	end
	asttimer-=1
	lasers_update()
	p_update()
end

function _draw()
	cls()
	stars_draw()
	asteroids_draw()
	border_draw()
	p_draw()
	lasers_draw()
end

function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end
-->8
function p_init()
	p={}
	p.x=56
	p.y=56
	p.dx=0
	p.dy=0
	p.g=0.05
	p.s=1
	p.fs=33
	p.fy=16
	p.fxl=4
	p.fxr=10
	p.ly=4
	p.llx=14
	p.lrx=0
end

function p_update()
	p.dy+=p.g
	
	if (btnp(🅾️)) p_fire(0)
	if (btnp(❎)) p_fire(1)
	
	if btn(0) then
		p.dy-=p.g*1.5
		p.dx-=p.g*0.5
	else
		if (p.dx<0) p.dx+=p.g*0.25
	end
	
	if btn(1) then
		p.dy-=p.g*1.5
		p.dx+=p.g*0.5
	else
		if (p.dx>0) p.dx-=p.g*0.25
	end
	
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
	y=p.y+p.ly
	if side==0 then
		x=p.x+p.lrx
	else
		x=p.x+p.llx
	end
	laser_init(x,y)
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
	binfo={}
	binfo.offset=0
	binfo.length=10
end

function border_update()
end

function border_draw()
end
-->8
function asteroids_init()
	astinfo={}
	astinfo.speedmin=0.5
	astinfo.speedmax=2
	astinfo.spr=5
	asteroids={}
end

function asteroids_update()
	for a in all (asteroids) do
		a.x+=a.dx
		a.y+=a.dy
		if (a.dx > 0 and a.x >= a.targetx) or (a.dx < 0 and a.x <= a.targetx) then
			del(asteroids,a)
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
	a.y=flr(rndb(0,56))
	a.targety=
		flr(rndb(0,56))
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
	
	add(asteroids,a)
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

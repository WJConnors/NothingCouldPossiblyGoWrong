pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	stars_init()
	p_init()
end

function _update()
	stars_update()
	p_update()
end

function _draw()
	cls()
	stars_draw()
	p_draw()
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
	p.llx=1
	p.lly=1
	p.lrx=3
	p.lry=3
	p.ls=3
end

function p_update()
	p.dy+=p.g
	
	if (btn(4)) p_fire(0)
	if (btn(5)) p_fire(1)
	
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
	if side==0 then
		x=p.llx
		y=p.lly
	else
		x=p.lrx
		y=p.lry
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

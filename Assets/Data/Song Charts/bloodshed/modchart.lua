local funnywindow = false
local funnywindowsmall = false
local NOMOREFUNNY = false
local strumy = 50

function setDefault(id)
    _G['defaultStrum'..id..'X'] = getActorX(id)
end

function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if funnywindow then
        setWindowPos(127 * math.sin(currentBeat * math.pi) + 327, 127 * math.sin(currentBeat * 3) + 160)
    end
    if funnywindowsmall then
        setWindowPos(24 * math.sin(currentBeat * math.pi) + 327, 24 * math.sin(currentBeat * 3) + 160)
    end
    if NOMOREFUNNY then
        setWindowPos(0 * math.sin(currentBeat * math.pi) + 327, 0 * math.sin(currentBeat * 3) + 160)
    end
    if daNoteMove then
        for i=4,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0.25) * math.pi), i)
            setActorY(defaultStrum0Y + 18 * math.cos((currentBeat + i*2.5) * math.pi), i)
        end
    end
	if daNoteMoveH then
        for i=4,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
        end
	end
	if daNoteMoveH2 then
        -- for i=4,7 do
        --    setActorX(_G['defaultStrum'..i..'X'] + 64 * math.sin((currentBeat) * math.pi), i)
		--	  setActorY(strumy + 18 * math.cos((currentBeat) * math.pi), i)
        -- end
	end
	if daNoteMoveH3 then
        for i=4,7 do
			setActorY(defaultStrum0Y + 128 * math.cos((currentBeat/4) * math.pi) + 128, i)
            setActorX(_G['defaultStrum'..i..'X'] + 128 * math.sin((currentBeat) * math.pi), i)
        end
	end
	if daNoteMoveH4 then
        for i=4,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 128 * math.sin((currentBeat) * math.pi), i)
			setActorY(strumy + 24 * math.cos((currentBeat) * math.pi), i)
		end
		camHudAngle = 10 * math.sin((currentBeat/6) * math.pi)
		cameraAngle = 2 * math.sin((currentBeat/6) * math.pi)
	end
	if daNoteMoveH5 then
        for i=4,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 128 * math.sin((currentBeat) * math.pi), i)
			setActorY(defaultStrum0Y + 96 * math.cos((currentBeat/4) * math.pi) + 96, i)
		end
		camHudAngle = 25 * math.sin((currentBeat/5) * math.pi)
		cameraAngle = 5 * math.sin((currentBeat/5) * math.pi)
	end
end
-- fixed the step they start at BECAUSE CYBER'S A IDIOT AND OFFSET ALL OF THEM
function stepHit(step)
    if curStep == 129 then
        funnywindowsmall = true
		for i=0,3 do
			tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 1250,getActorAngle(i)+359, 1, 'setDefault')
		end
		for i =4,7 do 
			tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i), 1, 'setDefault')
		end
    end
    if (curStep == 258) then
		daNoteMoveH2 = true
        funnywindowsmall = false
        funnywindow = true
    end
	if curStep == 389 then
		daNoteMoveH2 = false
		daNoteMoveH3 = true
	end
    if curStep == 518 then
		daNoteMoveH3 = false
		daNoteMoveH4 = true
        funnywindow = false
        funnywindowsmall = true
    end
    if curStep == 776 then
        funnywindowsmall = false
        funnywindow = true
        daNoteMoveH4 = false
        daNoteMoveH5 = true
    end
    if curStep >= 1053 then
        NOMOREFUNNY = true
        funnywindow = false
        funnywindowsmall = false
        if camHudAlpha > 0 then
			camHudAlpha = camHudAlpha - 0.05
		end
    end
end
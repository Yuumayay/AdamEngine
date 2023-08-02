function onUpdatePost()
    setTextString('scoreTxt', "Adam: Adam | Adam: Adam | Adam: Adam")
    setTextString('timeTxt', "Adam:Adam")
    setTextString('botplayTxt', "ADAM")
    setProperty('combo', 1212)
end

function onCreatePost()
    setProperty('timeBar.visible', false)
    makeLuaText("songName", songName.." | Adam Engine", 1000, 10, 690)
    setTextAlignment("songName", "left")
    addLuaText("songName")
    setTextSize("songName", 20, 20)
    setTextBorder("songName", 1, '000000')
    setProperty('canPause', false)
end

function noteMissPress()
    local health = getProperty('health')
    setProperty('health', health + 0.04)
end

function noteMiss()
    local health = getProperty('health')
    setProperty('health', health + 0.04)
end

function onUpdate(elapsed)
    if curBeat <= 95 then
        return
    end
    songPos = getSongPosition()
    local currentBeat = (songPos/3000)*(curBpm/100)
    local currentBeat2 = (songPos/3000)*(curBpm/18)
    local currentBeat3 = (songPos/3000)*(curBpm/12)
    doTweenX('1', 'dad', defaultGirlfriendX- 100 - 600*math.sin((currentBeat+4*1.25)*math.pi), 0.001)
    doTweenX('2', 'boyfriend', defaultGirlfriendX- 100 + 600*math.sin((currentBeat+4*1.25)*math.pi), 0.001)
    doTweenY('3', 'dad', defaultOpponentY- 100 - 150*math.sin((currentBeat2+4*1.25)*math.pi), 0.001)
    doTweenY('4', 'boyfriend', defaultBoyfriendY- 250 + 100*math.sin((currentBeat2+4*1.25)*math.pi), 0.001)
    doTweenY('5', 'iconP1', 100 - 100*math.sin((currentBeat2+4*1.25)*math.pi), 0.001)
    doTweenY('6', 'iconP2', 100 + 100*math.sin((currentBeat2+4*1.25)*math.pi), 0.001)
    doTweenAngle('7', 'healthBar', 100 - 100*math.sin((currentBeat3+4*1.25)*math.pi), 0.001)
    doTweenAngle('8', 'healthBarBG', 100 + 100*math.sin((currentBeat3+4*1.25)*math.pi), 0.001)
    doTweenX('9', 'camHUD', -100*math.sin((currentBeat+4*1.25)*math.pi), 0.001)
    doTweenAngle('10', 'camHUD', -5*math.sin((currentBeat+4*1.25)*math.pi), 0.001)
    noteTweenY('a', 4, 250 - 300*math.sin((currentBeat+4*1.25)*math.pi), 0.6)
    noteTweenY('b', 5, 250 - 300*math.sin((currentBeat+5*1.25)*math.pi), 0.6)
    noteTweenY('c', 6, 250 - 300*math.sin((currentBeat+6*1.25)*math.pi), 0.6)
    noteTweenY('d', 7, 250 - 300*math.sin((currentBeat+7*1.25)*math.pi), 0.6)
    noteTweenY('e', 0, 250 + 300*math.sin((currentBeat+4*2.25)*math.pi), 0.6)
    noteTweenY('f', 1, 250 + 300*math.sin((currentBeat+5*2.25)*math.pi), 0.6)
    noteTweenY('g', 2, 250 + 300*math.sin((currentBeat+6*2.25)*math.pi), 0.6)
    noteTweenY('h', 3, 250 + 300*math.sin((currentBeat+7*2.25)*math.pi), 0.6)
    noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 300*math.sin((currentBeat-4*0.25)*math.pi), 0.2)
    noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 300*math.sin((currentBeat-5*0.25)*math.pi), 0.2)
    noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 300*math.sin((currentBeat-6*0.25)*math.pi), 0.2)
    noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 300*math.sin((currentBeat-7*0.25)*math.pi), 0.2)
    noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 - 300*math.sin((currentBeat-4*0.25)*math.pi), 0.3)
    noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 - 300*math.sin((currentBeat-5*0.25)*math.pi), 0.3)
    noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 - 300*math.sin((currentBeat-6*0.25)*math.pi), 0.3)
    noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 - 300*math.sin((currentBeat-7*0.25)*math.pi), 0.3)
end
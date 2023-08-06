function onCreate()
    makeLuaSprite('healthMax', '', 0, 0)
    makeGraphic('healthMax', 600, 18, '000000')
    addLuaSprite('healthMax', true)
    setObjectCamera('healthMax', 'hud')
    setLuaSpriteScrollFactor('healthMax', 0, 0)
    setObjectOrder('healthMax', 18)
    setProperty('healthMax.scale.x', 0)

    makeLuaSprite('blackscreen', '', 0, 0)
    makeGraphic('blackscreen', 1920, 1080, '000000')
    addLuaSprite('blackscreen', true)
    setObjectCamera('blackscreen', 'other')
    setLuaSpriteScrollFactor('blackscreen', 0, 0)
    setProperty('blackscreen.alpha', 0)
end

function goodNoteHit()
    local health = getProperty('health')

    setProperty('health', (health + (2 / (health + 2) / 20)) - 0.023)
end

function noteMiss()
    setProperty('healthMax.scale.x', getProperty('healthMax.scale.x') + 0.1)
    playSound('over-missed', 1)
    cameraFlash('game', 'FFFFFF', 0.5, true)
    cameraFlash('hud', 'FFFFFF', 0.5, true)
    cameraFlash('other', 'FFFFFF', 0.5, true)
    characterPlayAnim('boyfriend', 'hurt', true)
    setProperty('boyfriend.specialAnim', true)
    cameraShake('camGame', 0.01, 0.2)
    runTimer('damage', 0.01, 10)
end

function onUpdate()
    setProperty('healthMax.x', (getProperty('healthBarBG.x') - 300) + 600 * getProperty('healthMax.scale.x') / 2)
    setProperty('healthMax.y', getProperty('healthBarBG.y'))
    local health = getProperty('health')
    local misses = getProperty('songMisses')
    local songPos = getSongPosition()
    local section = math.floor(curBeat / 4)
    setProperty('blackscreen.alpha', (2 - health) * 0.25)
    if health > 2 - misses * 0.2 then
        setProperty('health', 2 - misses * 0.2)
    end
    if section >= 0 and section <= 16 then
        doTweenAngle('camTw', 'camHUD', math.sin(songPos / 1000) * 10, 0.001)
    end
    if section >= 17 and section <= 32 then
        doTweenAngle('camTw', 'camHUD', math.sin(songPos / 250) * 10, 0.001)
    end
    if section >= 33 and section <= 48 then
        doTweenAngle('camTw', 'camHUD', math.sin(songPos / 200) * 25, 0.001)
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0 + math.sin(songPos / 200) * 100, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0 + math.sin(songPos / 200) * 100, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0 + math.sin(songPos / 200) * 100, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0 + math.sin(songPos / 200) * 100, 0.001)
        noteTweenX('noteTw5', 4, 415 + math.sin(songPos / 300) * 100, 0.001)
        noteTweenX('noteTw6', 5, 525 + math.sin(songPos / 300) * 100, 0.001)
        noteTweenX('noteTw7', 6, 635 + math.sin(songPos / 300) * 100, 0.001)
        noteTweenX('noteTw8', 7, 745 + math.sin(songPos / 300) * 100, 0.001)
    end
    if section >= 49 and section <= 56 then
        doTweenAngle('camTw', 'camHUD', math.sin(songPos / 1000) * 10, 0.001)
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0 + math.sin(songPos / 200) * 100, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0 + math.sin(songPos / 250) * 100, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0 + math.sin(songPos / 300) * 100, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0 + math.sin(songPos / 350) * 100, 0.001)
        noteTweenX('noteTw5', 4, 415 + math.sin(songPos / 500) * 100, 0.001)
        noteTweenX('noteTw6', 5, 525 + math.sin(songPos / 500) * 100, 0.001)
        noteTweenX('noteTw7', 6, 635 + math.sin(songPos / 500) * 100, 0.001)
        noteTweenX('noteTw8', 7, 745 + math.sin(songPos / 500) * 100, 0.001)
    end
    if section >= 57 and section <= 64 then
        doTweenAngle('camTw', 'camHUD', 0, 0.001)
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0, 0.001)
        noteTweenX('noteTw5', 4, 415, 0.001)
        noteTweenX('noteTw6', 5, 525, 0.001)
        noteTweenX('noteTw7', 6, 635, 0.001)
        noteTweenX('noteTw8', 7, 745, 0.001)
    end
    if section >= 97 and section <= 112 then
        doTweenAngle('camTw', 'camHUD', math.sin(songPos / 250) * 25, 0.001)
    end
end

function onBeatHit()
    local section = math.floor(curBeat / 4)
    if section >= 65 and section <= 80 then
        doTweenAngle('camTw', 'camHUD', 0, 0.001)
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0, 0.001)
        if curBeat % 2 == 0 then
            noteTweenX('noteTw5', 4, 315, 0.1, 'quadOut')
            noteTweenX('noteTw6', 5, 425, 0.1, 'quadOut')
            noteTweenX('noteTw7', 6, 735, 0.1, 'quadOut')
            noteTweenX('noteTw8', 7, 845, 0.1, 'quadOut')
        else
            noteTweenX('noteTw5', 4, 415, 0.1, 'quadOut')
            noteTweenX('noteTw6', 5, 525, 0.1, 'quadOut')
            noteTweenX('noteTw7', 6, 635, 0.1, 'quadOut')
            noteTweenX('noteTw8', 7, 745, 0.1, 'quadOut')
        end
    end
    if section >= 81 and section <= 96 then
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0, 0.001)
        if curBeat % 2 == 0 then
            doTweenAngle('camTw', 'camHUD', 20, 0.001)
        else
            doTweenAngle('camTw', 'camHUD', -20, 0.001)
        end
    end
    if section >= 97 and section <= 112 then
        noteTweenY('noteTw1', 4, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw2', 5, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw3', 6, defaultPlayerStrumY0, 0.001)
        noteTweenY('noteTw4', 7, defaultPlayerStrumY0, 0.001)
        if curBeat % 2 == 0 then
            noteTweenX('noteTw5', 4, 215, 0.1, 'quadOut')
            noteTweenX('noteTw6', 5, 325, 0.1, 'quadOut')
            noteTweenX('noteTw7', 6, 835, 0.1, 'quadOut')
            noteTweenX('noteTw8', 7, 945, 0.1, 'quadOut')
        else
            noteTweenX('noteTw5', 4, 415, 0.1, 'quadOut')
            noteTweenX('noteTw6', 5, 525, 0.1, 'quadOut')
            noteTweenX('noteTw7', 6, 635, 0.1, 'quadOut')
            noteTweenX('noteTw8', 7, 745, 0.1, 'quadOut')
        end
    end
    if curBeat == 452 then
        doTweenAngle('camTw', 'camHUD', 720, 2, 'quadOut')
        doTweenY('camEndingX', 'camHUD', 20000, 100, 'quadOut')
        doTweenAlpha('camEndingAlpha', 'camHUD', 0, 2, 'quadOut')
    end
end

function onStepHit()
    local section = math.floor(curBeat / 4)
    --debugPrint(section)
    local songPos = getSongPosition()
    cameraShake('camGame', songPos / 10000000, 0.2)
    cameraShake('camHUD', songPos / 10000000, 0.2)
end

function opponentNoteHit()
    local health = getProperty('health')
    setProperty('health', health - health / 25)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'damage' then
        local health = getProperty('health')
        setProperty('health', health - health / 8)
    end
end
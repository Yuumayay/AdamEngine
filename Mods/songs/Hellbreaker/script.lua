function onStartCountdown()
setProperty('health', 2)
end

function onUpdate(elapsed)
songPos = getSongPosition()
local currentBeat2 = (songPos/1000)*(curBpm/60)
local currentBeat = (songPos/5000)*(curBpm/60)
setCharacterX('dad',getCharacterX('dad') + (math.sin(currentBeat2) * 1.4))
setCharacterY('dad',getCharacterY('dad') + (math.cos(currentBeat2) * 1.4))
function onMoveCamera(focus)
	if focus == 'boyfriend' then
		-- called when the camera focus on boyfriend
	elseif focus == 'dad' then
		setProperty('camFollowPos.y',getProperty('camFollowPos.y') + (math.sin(currentBeat) * 0.6))
	end
end
setProperty('camHUD.angle',0 - 5 * math.cos((currentBeat2*0.25)*math.pi) )
setProperty('camHUD.y',0 - 15 * math.cos((currentBeat2*0.25)*math.pi) )
setProperty('camHUD.x',0 - 10 * math.sin((currentBeat2*0.25)*math.pi) )


noteTweenX(defaultPlayerStrumX0, 4, ((screenWidth / 2) + (157 / 2)) - (math.sin((currentBeat2) - 0) * 300), 0.001)
noteTweenX(defaultPlayerStrumX1, 5, ((screenWidth / 2) +(157 / 2))- (math.sin((currentBeat2) - 1) * 300), 0.001)
noteTweenX(defaultPlayerStrumX2, 6, ((screenWidth / 2)  + (157 / 2))- (math.sin((currentBeat2) - 2) * 300), 0.001)
noteTweenX(defaultPlayerStrumX3, 7, ((screenWidth / 2)  + (157 / 2)) - (math.sin((currentBeat2) - 3) * 300), 0.001)
noteTweenY('defaultPlayerStrumY0', 4, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 0) * 157), 0.001)
noteTweenY('defaultPlayerStrumY1', 5, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 1) * 157), 0.001)
noteTweenY('defaultPlayerStrumY2', 6, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 2) * 157), 0.001)
noteTweenY('defaultPlayerStrumY3', 7, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 3) * 157), 0.001)
noteTweenX('fake1', 0, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (4) * 2) * 300), 0.001)
noteTweenX('fake2', 1, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (5) * 2) * 300), 0.001)
noteTweenX('fake3', 2, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (6) * 2) * 300), 0.001)
noteTweenX('fake4', 3, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (7) * 2) * 300), 0.001)
noteTweenY('defaultFPlayerStrumY0', 0, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (4) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY1', 1, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (5) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY2', 2, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (6) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY3', 3, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (7) * 2) * 157), 0.001)
if curBeat == 1264 then

noteTweenX(defaultPlayerStrumX0, 4, ((screenWidth / 2) + (157 / 2)) - (math.sin((currentBeat2) - 0) * 300), 0.001)
noteTweenX(defaultPlayerStrumX1, 5, ((screenWidth / 2) +(157 / 2))- (math.sin((currentBeat2) - 1) * 300), 0.001)
noteTweenX(defaultPlayerStrumX2, 6, ((screenWidth / 2)  + (157 / 2))- (math.sin((currentBeat2) - 2) * 300), 0.001)
noteTweenX(defaultPlayerStrumX3, 7, ((screenWidth / 2)  + (157 / 2)) - (math.sin((currentBeat2) - 3) * 300), 0.001)
noteTweenY('defaultPlayerStrumY0', 4, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 0) * 157), 0.001)
noteTweenY('defaultPlayerStrumY1', 5, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 1) * 157), 0.001)
noteTweenY('defaultPlayerStrumY2', 6, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 2) * 157), 0.001)
noteTweenY('defaultPlayerStrumY3', 7, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + 3) * 157), 0.001)
noteTweenX('fake1', 0, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (4) * 2) * 300), 0.001)
noteTweenX('fake2', 1, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (5) * 2) * 300), 0.001)
noteTweenX('fake3', 2, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (6) * 2) * 300), 0.001)
noteTweenX('fake4', 3, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (7) * 2) * 300), 0.001)
noteTweenY('defaultFPlayerStrumY0', 0, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (4) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY1', 1, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (5) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY2', 2, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (6) * 2) * 157), 0.001)
noteTweenY('defaultFPlayerStrumY3', 3, ((screenHeight / 2) - (300 / 2)) + (math.cos((currentBeat) + (7) * 2) * 157), 0.001)
end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
cameraShake(game, 0.015, 0.2)
cameraSetTarget('dad')
characterPlayAnim('gf', 'scared', true)
doTweenZoom('camerazoom','camGame',1.05,0.15,'quadInOut')
setProperty('health', getProperty('health') - 1 * ((getProperty('health')/22))/6)
end
function goodNoteHit(id, direction, noteType, isSustainNote)
cameraSetTarget('boyfriend')
end

function noteMiss(direction)
setProperty('health', getProperty('health') + 0.023)
end
function noteMissPress(direction)
setProperty('health', getProperty('health') + 0.023)
end


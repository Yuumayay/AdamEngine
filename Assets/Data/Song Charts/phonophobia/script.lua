--bro i made this impossible originally and joolian told me to nerf it i had to nerf it like 12 times before i decided to restart so dont even say "oh oof its too easy make it harder" fuck off -OOF PRODUCTIONS

--cope harder - Joolian
local thing = 1
function onCreate()
	setProperty('camHUD.zoom', 5)
	setProperty('camGame.zoom', 1.5)
	doTweenZoom('tweeningZoomin', 'camGame', 0.9, 8, 'quadOut')

	local botPlay = getProperty('cpuControlled');
end


function onUpdate(elapsed)
	songPos = getSongPosition()
	local currentBeat = (songPos/300)*(curBpm/100)
	local currentBeat2 = (songPos/1234)*(curBpm/100)
	setCharacterY('dad',getCharacterY('dad') + (math.sin(currentBeat) * 1.6))
	noteTweenX(defaultPlayerStrumX0, 4, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat) + 0) * 300), 0.001)
	noteTweenX(defaultPlayerStrumX1, 5, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat) + 1) * 300), 0.001)
	noteTweenX(defaultPlayerStrumX2, 6, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat) + 2) * 300), 0.001)
	noteTweenX(defaultPlayerStrumX3, 7, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat) + 3) * 300), 0.001)
	noteTweenY('defaultPlayerStrumY0', 4, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + 0) * 150), 0.001)
	noteTweenY('defaultPlayerStrumY1', 5, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + 1) * 150), 0.001)
	noteTweenY('defaultPlayerStrumY2', 6, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + 2) * 150), 0.001)
	noteTweenY('defaultPlayerStrumY3', 7, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + 3) * 150), 0.001)
	noteTweenX('fake1', 0, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (4) * 2) * 300), 0.001)
	noteTweenX('fake2', 1, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (5) * 2) * 300), 0.001)
	noteTweenX('fake3', 2, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (6) * 2) * 300), 0.001)
	noteTweenX('fake4', 3, ((screenWidth / 2) - (157 / 2)) + (math.sin((currentBeat2) + (7) * 2) * 300), 0.001)
	noteTweenY('defaultFPlayerStrumY0', 0, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + (4) * 2) * 150), 0.001)
	noteTweenY('defaultFPlayerStrumY1', 1, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + (5) * 2) * 150), 0.001)
	noteTweenY('defaultFPlayerStrumY2', 2, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + (6) * 2) * 150), 0.001)
	noteTweenY('defaultFPlayerStrumY3', 3, ((screenHeight / 2) - (78 / 2)) + (math.cos((currentBeat) + (7) * 2) * 150), 0.001)
	function opponentNoteHit(id, direction, noteType, isSustainNote)
	cameraShake(game, 0.015, 0.15)
end	
	if curStep >= 0 then
	  songPos = getSongPosition()
	  local currentBeat = (songPos/1000)*(bpm/300)
	  doTweenY(dadTweenY, 'dad', 290-130*math.sin((currentBeat*0.25)*math.pi),0.001)
	end
end


function opponentNoteHit()
	triggerEvent('Screen Shake', '0.1, 0.01', '0.1, 0.01');
		health = getProperty('health')
		if health > 1 then
			setProperty('health', health - 0.001);	
		end
		end

function onBeatHit()
	if curBeat >= 60 then
		doTweenZoom('tweeningZoom', 'camHUD', 1, 3, 'quadOut')
		thing = thing * -1
		doTweenAngle('rotate', 'camHUD', thing * 5, crochet / 1000, 'quadInOut')
	end
end

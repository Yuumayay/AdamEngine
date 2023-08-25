function onCreate()
	debugPrint(getProperty('boyfriend.stunned'))
	addCharacterToList('bf_trail', 'trail')
	precacheImage('BOYFRIEND')
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Trail' then 
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

local singAnims = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Trail' then
		characterPlayAnim('gf', singAnims[direction + 1], true);
	end
end

local singAnims = {8, 5, 17, 13}
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Trail' then
		makeAnimatedLuaSprite('bf_trail', 'BOYFRIEND', getProperty('boyfriend.x'), getProperty('boyfriend.y'))
		doTweenColor('bfTrailColor', 'bf_trail', '7777FF', 0.001)
		addLuaSprite('bf_trail', true)
		doTweenAlpha('bfTrailTween', 'bf_trail', 0, 5)
		setProperty('bf_trail.animation.curFrame', singAnims[direction + 1])
	end
end

function noteMiss(id, direction, noteType, isSustainNote)

end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.001);
	end
end
function noteMiss()
    health = getProperty('health')
    setProperty('health', health + 0.13);
end

function goodNoteHit(id, dir, type, sustain)
	health = getProperty('health')
	if not sustain then
	    if getPropertyFromGroup('notes', id, 'rating') == 'sick' then
		setProperty('health', health-0)
	    elseif getPropertyFromGroup('notes', id, 'rating') == 'good' then
		setProperty('health', health+0.01)
	    elseif getPropertyFromGroup('notes', id, 'rating') == 'bad' then
		setProperty('health', health+0.05)
	    elseif getPropertyFromGroup('notes', id, 'rating') == 'shit' then
		setProperty('health', health+0.075)
	    end
	end
end

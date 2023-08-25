function opponentNoteHit()
    misses = getProperty('songMisses')
    health = getProperty('health')
    setProperty('health', health-0.01);
end
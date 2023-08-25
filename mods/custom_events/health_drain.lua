function onBeatHit()
    misses = getProperty('songMisses')
    health = getProperty('health')
    setProperty('health', health-misses* 0.005);
end
function onUpdate(elapsed)
    if curStep >= 0 then
      songPos = getSongPosition()
      local currentBeat = (songPos / 1000) * (bpm / 200)
      doTweenAngle(1, 'dad', 490 - 130 * math.sin((currentBeat * 999) * math.pi), 0.001)
      doTweenAngle(2, 'iconP2', 490 - 130 * math.sin((currentBeat * 999) * math.pi), 0.001)
    end
end
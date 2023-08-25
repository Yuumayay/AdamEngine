function onUpdate(elapsed)
songPos = getSongPosition()
local currentBeat = (songPos/3000)*(curBpm/100)

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
function onUpdate(elapsed)
songPos = getSongPosition()
local currentBeat = (songPos/3000)*(curBpm/18)

        noteTweenY('a', 4, defaultPlayerStrumY0 - 500*math.sin((currentBeat+4*1.25)*math.pi), 0.6)
        noteTweenY('b', 5, defaultPlayerStrumY1 - 500*math.sin((currentBeat+5*1.25)*math.pi), 0.6)
        noteTweenY('c', 6, defaultPlayerStrumY2 - 500*math.sin((currentBeat+6*1.25)*math.pi), 0.6)
        noteTweenY('d', 7, defaultPlayerStrumY3 - 500*math.sin((currentBeat+7*1.25)*math.pi), 0.6)

        noteTweenY('e', 0, defaultOpponentStrumY0 + 500*math.sin((currentBeat+4*2.25)*math.pi), 0.6)
        noteTweenY('f', 1, defaultOpponentStrumY1 + 500*math.sin((currentBeat+5*2.25)*math.pi), 0.6)
        noteTweenY('g', 2, defaultOpponentStrumY2 + 500*math.sin((currentBeat+6*2.25)*math.pi), 0.6)
        noteTweenY('h', 3, defaultOpponentStrumY3 + 500*math.sin((currentBeat+7*2.25)*math.pi), 0.6)

        noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 500*math.sin((currentBeat-4*0.25)*math.pi), 0.2)
        noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 500*math.sin((currentBeat-5*0.25)*math.pi), 0.2)
        noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 500*math.sin((currentBeat-6*0.25)*math.pi), 0.2)
        noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 500*math.sin((currentBeat-7*0.25)*math.pi), 0.2)

        noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 - 500*math.sin((currentBeat-4*0.25)*math.pi), 0.3)
        noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 - 500*math.sin((currentBeat-5*0.25)*math.pi), 0.3)
        noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 - 500*math.sin((currentBeat-6*0.25)*math.pi), 0.3)
        noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 - 500*math.sin((currentBeat-7*0.25)*math.pi), 0.3)
end
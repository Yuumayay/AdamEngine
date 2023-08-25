extends Node

func onCreate():
	Modchart.keyToMove("Debug", "Adamized", "7")
	Modchart.setGhostTapping()
	Modchart.glitch()

func onUpdate():
	if Audio.cur_step >= 0:
		var songPos = Modchart.getSongPosition()
		var currentBeat = (songPos / 1000.0) * (Audio.bpm / 200.0)
		Modchart.doTweenAngle(1, 'dad', 490 - 130 * sin((currentBeat * 999) * PI), 0.001)
		Modchart.doTweenAngle(2, 'iconP2', 490 - 130 * sin((currentBeat * 999) * PI), 0.001)
extends Node

func onCreate():
	Modchart.setHealthDrain()

func onBeatHit():
	if Audio.cur_beat == 15:
		Modchart.hideUI()
		Modchart.camZoomDad(1.8, -1, 4, 4, Vector2(0, -100))
		Modchart.drawLyrics("Ugh!")
	if Audio.cur_beat == 16:
		Modchart.showUI()
		Modchart.camReset()
		Modchart.drawLyrics("")
	if Audio.cur_beat == 30:
		Modchart.camZoomBF(1.4, -1, 4, 4, Vector2(0, -100))
	if Audio.cur_beat == 31:
		Modchart.camZoomBF(1.8, -1, 4, 4, Vector2(0, -100))
	if Audio.cur_beat == 32:
		Modchart.camReset()

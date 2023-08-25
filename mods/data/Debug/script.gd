extends Node

var glitchValue := 0.001

var conv_adam = [["0", "a"], ["1", "d"], ["2", "m"], ["3", "ȧ"], ["4", "ḋ"], ["5", "ṁ"], ["6", "A"], ["7", "D"], ["8", "M"], ["9", "Ȧ"]]

func convertAdam(text):
	text = text.replacen("0", "a").replacen("1", "d").replacen("2", "m").replacen("3", "A").replacen("4", "D").replacen("5", "M").replacen("6", "A.").replacen("7", "D.").replacen("8", "M.").replacen("9", "A:")
	return text

func onCreate():
	Modchart.stopUpdateText()

func onUpdate():
	if Game.who_sing[Audio.cur_section]:
		Modchart.camZoomBF(0.75)
	else:
		Modchart.camZoomDad(0.75)
	glitchValue = lerp(glitchValue, 0.001, 0.1)
	Modchart.glitch(glitchValue)
	Modchart.setHealthDrain(0.02)
	var perf = convertAdam(str(Game.rating_total[Game.PERF]))
	var sick = convertAdam(str(Game.rating_total[Game.SICK]))
	var good = convertAdam(str(Game.rating_total[Game.GOOD]))
	var bad = convertAdam(str(Game.rating_total[Game.BAD]))
	var shit = convertAdam(str(Game.rating_total[Game.SHIT]))
	var miss = convertAdam(str(Game.rating_total[Game.MISS]))
	var combo = convertAdam(str(Game.combo))
	var maxcombo = convertAdam(str(Game.max_combo))
	var acc = convertAdam(str(Game.accuracy_percent))
	var time = convertAdam(Game.timeText)
	var score = convertAdam(str(Game.score))
	var adm = "Adam: "
	Modchart.setTextString("infoTxt", adm + perf + "\n" + adm + sick + "\n" + adm + good + "\n" + adm + bad + "\n" + adm + shit + "\n" + adm + miss + "\n" + " " + "\n" + adm + combo + "\nMax Adam: " + maxcombo)
	Modchart.setTextString("scoreTxt", "Adam: " + score + " | Adam: " + miss + " | Adam: Adam!! (" + acc + ") - ADAM")
	Modchart.setTextString("timeTxt", time)

func onBeatHit():
	glitchValue = 0.01

func oldModchart():
	var section = Audio.cur_section
	if section >= 32 and section <= 64:
		var step : int = Audio.cur_step
		var layer_list : Array = ["info", "ui", "strums", "notes"]
		for i in layer_list:
			if step % 32 == 0:
				Modchart[i].transform.x.x = -1
				Modchart[i].offset.x = View.SCREEN_X
			elif step % 32 == 8:
				Modchart[i].transform.y.y = -1
				Modchart[i].offset.y = View.SCREEN_Y
			elif step % 32 == 16:
				Modchart[i].transform.x.x = 1
				Modchart[i].offset.x = 0
			elif step % 32 == 20:
				Modchart[i].transform.y.y = 1
				Modchart[i].offset.y = 0
			elif step % 32 == 22:
				Modchart[i].transform.x.x = -1
				Modchart[i].offset.x = View.SCREEN_X
			elif step % 32 == 26:
				Modchart[i].transform.y.y = -1
				Modchart[i].offset.y = View.SCREEN_Y
			elif step % 32 == 28:
				Modchart[i].transform.x.x = 1
				Modchart[i].transform.y.y = 1
				Modchart[i].offset.x = 0
				Modchart[i].offset.y = 0

func onSectionHit():
	if Audio.cur_section >= 28:
		Flash.flash()
	glitchValue += 0.1

func opponentNoteHit():
	Modchart.cameraShake(50, 0.005)

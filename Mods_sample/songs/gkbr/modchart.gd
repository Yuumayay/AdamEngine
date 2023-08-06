extends Node

func onCreate():
	Game.iconBF = "teto"
	Game.iconDAD = "none"
	Modchart.drawBlackBG()
	Modchart.setMiddleScroll()

func onSectionHit():
	if Audio.cur_section == 10:
		Game.iconDAD = "gkbr"

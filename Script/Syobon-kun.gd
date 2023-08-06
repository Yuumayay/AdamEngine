extends CanvasLayer

@onready var lHand = $Hand
@onready var rHand = $Hand2

func _process(_delta):
	if Setting.s_get("graphics", "syobon-kun") and !visible:
		show()
	if Game.cur_state == Game.PLAYING:
		if Game.cur_input[0] != 0 and Game.cur_input[1] != 0:
			lHand.frame = 2
		elif Game.cur_input[0] != 0:
			lHand.frame = 0
		elif Game.cur_input[1] != 0:
			lHand.frame = 1
		else:
			lHand.frame = 7
			
		if Game.cur_input[2] != 0 and Game.cur_input[3] != 0:
			rHand.frame = 5
		elif Game.cur_input[2] != 0:
			rHand.frame = 3
		elif Game.cur_input[3] != 0:
			rHand.frame = 4
		else:
			rHand.frame = 6

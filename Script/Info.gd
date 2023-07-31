extends CanvasLayer

var last_hit = 0

@onready var info1 = $Label1
@onready var info2 = $Label2
@onready var info3 = $Label3
@onready var info4 = $Label4

var adam_conditions: Array = [["Perfect!!", "PFC"], ["Sick!", 1.0], ["Great", 0.9], ["Good", 0.8],
 ["Nice", 0.7], ["Meh", 0.69], ["Bruh", 0.6], ["Bad", 0.5], ["Shit", 0.4], ["You Suck!", 0.2]]

func _ready():
	info1.text = "Score: 0 | Misses: 0 | Rating: N/A"
	info2.text = ""
	info2.text += "Marvelous: 0\n"
	info2.text += "Sick: 0\n"
	info2.text += "Good: 0\n"
	info2.text += "Bad: 0\n"
	info2.text += "Shit: 0\n"
	info2.text += "Misses: 0\n\n"
	info2.text += "Combo: 0\n"
	info2.text += "Max Combo: 0\n"
	
	var lower = Game.cur_song.to_lower()
	if Game.cur_song.to_lower() == lower:
		info4.text = Game.cur_song[0].to_upper() + Game.cur_song.substr(1) + " - " + Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1)
	else:
		info4.text = Game.cur_song[0] + " - " + Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1)

func _process(_delta):
	if last_hit != Game.hit:
		last_hit = Game.hit
		var fc_state: String = fc_state_check()
		var rating_text: String = rating_text_check()

		info1.text = "Score: " + str(Game.score) + " | Misses: " + str(Game.rating_total[Game.MISS]) + " | Rating: " + rating_text + " (" + str(floor(Game.accuracy * 10000.0) / 100.0) + "%) " + fc_state
		
		info2.text = ""
		info2.text += "Marvelous: " + str(Game.rating_total[Game.PERF]) + "\n"
		info2.text += "Sick: " + str(Game.rating_total[Game.SICK]) + "\n"
		info2.text += "Good: " + str(Game.rating_total[Game.GOOD]) + "\n"
		info2.text += "Bad: " + str(Game.rating_total[Game.BAD]) + "\n"
		info2.text += "Shit: " + str(Game.rating_total[Game.SHIT]) + "\n"
		info2.text += "Misses: " + str(Game.rating_total[Game.MISS]) + "\n\n"
		info2.text += "Combo: " + str(Game.combo) + "\n"
		info2.text += "Max Combo: " + str(Game.max_combo) + "\n"
		
		info3.text = View.version_text

func fc_state_check():
	var fc_state: String
	if Game.rating_total[Game.PERF] > 0:
		Game.fc_state = "MFC"
		fc_state = "- MFC"
	if Game.rating_total[Game.SICK] > 0:
		Game.fc_state = "SFC"
		fc_state = "- SFC"
	if Game.rating_total[Game.GOOD] > 0:
		Game.fc_state = "GFC"
		fc_state = "- GFC"
	if Game.rating_total[Game.BAD] > 0 or Game.rating_total[Game.SHIT] > 0:
		Game.fc_state = "FC"
		fc_state = "- FC"
	if Game.rating_total[Game.MISS] > 0:
		Game.fc_state = "SDCB"
		fc_state = "- SDCB"
	if Game.rating_total[Game.MISS] >= 10:
		Game.fc_state = "Clear"
		fc_state = "- Clear"
	return fc_state

func rating_text_check():
	var rating_text: String
	for i in adam_conditions:
		if i[1] is String:
			if i[1] == "PFC":
				if Game.fc_state == "MFC" or Game.fc_state == "SFC":
					rating_text = i[0]
					break
		else:
			if i[1] >= Game.accuracy:
				rating_text = i[0]
	return rating_text

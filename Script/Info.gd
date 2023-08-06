extends CanvasLayer

var last_hit = 0

@onready var info1 = $Label1
@onready var info2 = $Label2
@onready var info3 = $Label3
@onready var info4 = $Label4
@onready var kpsinfo = $KPS

var adam_conditions: Array = [["Perfect!!", "PFC"], ["Sick!", 1.0], ["Great", 0.9], ["Good", 0.8],
 ["Nice", 0.7], ["Meh", 0.69], ["Bruh", 0.6], ["Bad", 0.5], ["Shit", 0.4], ["You Suck!", 0.2]]


func _ready():
	await Modchart.modchart_ready
	if not Setting.s_get("gameplay", "downscroll"):
		info1.position.y = 600
	
	
	Setting.set_dfont_mini(info1)
	Setting.set_dfont_mini(info2)
	
	if Setting.eng():
		if Modchart.mGet("defeat", 2):
			info1.text = "Score: 0 | Misses: 0 / " + str(Modchart.mGet("defeat", 0) - 1) + " | Rating: N/A"
		else:
			info1.text = "Score: 0 | Misses: 0 | Rating: N/A"
#		info2.text += "Marvelous: " + str(Game.rating_total[Game.PERF]) + "\n"
#		info2.text += "Sick: " + str(Game.rating_total[Game.SICK]) + "\n"
#		info2.text += "Good: " + str(Game.rating_total[Game.GOOD]) + "\n"
#		info2.text += "Bad: " + str(Game.rating_total[Game.BAD]) + "\n"
#		info2.text += "Shit: " + str(Game.rating_total[Game.SHIT]) + "\n"
#		info2.text += "Misses: " + str(Game.rating_total[Game.MISS]) + "\n\n"
#		info2.text += "Combo: " + str(Game.combo) + "\n"
#		info2.text += "Max Combo: " + str(Game.max_combo) + "\n"
	elif Setting.jpn():
		if Modchart.mGet("defeat", 2):
			info1.text = "Score: 0 | Miss: 0 / " + str(Modchart.mGet("defeat", 0) - 1) + " | Rank: ?"
		else:
			info1.text = "Score: 0 | Miss: 0 | Rank: ?"
#		info2.text += "スゲェ: " + str(Game.rating_total[Game.PERF]) + "\n"
#		info2.text += "イイネ: " + str(Game.rating_total[Game.SICK]) + "\n"
#		info2.text += "フツー: " + str(Game.rating_total[Game.GOOD]) + "\n"
#		info2.text += "ウーン: " + str(Game.rating_total[Game.BAD]) + "\n"
#		info2.text += "ダメダメ: " + str(Game.rating_total[Game.SHIT]) + "\n"
#		info2.text += "ミス: " + str(Game.rating_total[Game.MISS]) + "\n" + " " + "\n"
#		info2.text += "Combo: " + str(Game.combo) + "\n"
#		info2.text += "Max Combo: " + str(Game.max_combo) + "\n"

	updateComboInfo()
	
	var lower = Game.cur_song.to_lower()
	if Game.cur_song.to_lower() == lower:
		info4.text = Game.cur_song[0].to_upper() + Game.cur_song.substr(1) + " - " + Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1)
	else:
		info4.text = Game.cur_song[0] + " - " + Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1)
	
	await get_tree().create_timer(0.26).timeout
	updateComboInfo()

func updatePos():
	if not Setting.s_get("gameplay", "downscroll"):
		info1.position.y = 600
	else:
		info1.position.y = 129

func _process(delta):
	if Setting.s_get("graphics", "show kps"):
		if !kpsinfo.visible:
			kpsinfo.show()
		var total := 0.0
		var count := 0
		for i in Game.kps.size():
			if Game.kps[count] < 0.0:
				Game.kps.remove_at(count)
				if Game.kps.size() != 0:
					count -= 1
				else:
					break
			total += Game.kps[count]
			Game.kps[count] -= delta
			count += 1
		if total < 0.0:
			total = 0.0
		kpsinfo.text = str("%0.2f" % total)
		if total >= 0:
			kpsinfo.add_theme_color_override("font_color", Color(1 - total / 50, 1, 1))
		if total >= 10:
			kpsinfo.add_theme_color_override("font_color", Color(total / 50 + 0.6, 1, 1 - total / 40))
		if total >= 20:
			kpsinfo.add_theme_color_override("font_color", Color(1, 1 - total / 50, 1 - total / 40))
		if total >= 30:
			kpsinfo.add_theme_color_override("font_color", Color(1, 1 - total / 50, 1 - total / 40))
		if total >= 40:
			kpsinfo.add_theme_color_override("font_color", Color(1, 0, 1 - 40 / total))
	if last_hit != Game.hit:
		last_hit = Game.hit
		var fc_state: String = fc_state_check()
		var rating_text: String = rating_text_check()
		
		#if Setting.eng():
		if Modchart.mGet("defeat", 2):
			info1.text = "Score: " + str(Game.score) + " | Misses: " + str(Game.rating_total[Game.MISS]) + " / " + str(Modchart.mGet("defeat", 0) - 1) + " | Rating: " + Setting.translate(rating_text) + " (" + str(floor(Game.accuracy * 10000.0) / 100.0) + "%) " + fc_state
		else:
			info1.text = "Score: " + str(Game.score) + " | Misses: " + str(Game.rating_total[Game.MISS]) + " | Rating: " + Setting.translate(rating_text) + " (" + str(floor(Game.accuracy * 10000.0) / 100.0) + "%) " + fc_state
		#elif Setting.lang == "japanese":
		#	if Modchart.mGet("defeat", 2):
		#		info1.text = "Score: " + str(Game.score) + " | Miss: " + str(Game.rating_total[Game.MISS]) + " / " + str(Modchart.mGet("defeat", 0) - 1) + " | Rank: " + Setting.translate(rating_text) + " (" + str(floor(Game.accuracy * 10000.0) / 100.0) + "%) " + fc_state
		#	else:
		#		info1.text = "Score: " + str(Game.score) + " | Miss: " + str(Game.rating_total[Game.MISS]) + " | Rank: " + Setting.translate(rating_text) + " (" + str(floor(Game.accuracy * 10000.0) / 100.0) + "%) " + fc_state
		
		updateComboInfo()
		
		info3.text = View.version_text

func updateComboInfo():
	info2.text = ""
	
	if Setting.jpn():
		info2.text += "スゲェ: " + str(Game.rating_total[Game.PERF]) + "\n"
		info2.text += "イイネ: " + str(Game.rating_total[Game.SICK]) + "\n"
		info2.text += "フツー: " + str(Game.rating_total[Game.GOOD]) + "\n"
		info2.text += "ウーン: " + str(Game.rating_total[Game.BAD]) + "\n"
		info2.text += "ダメダメ: " + str(Game.rating_total[Game.SHIT]) + "\n"
		info2.text += "ミス: " + str(Game.rating_total[Game.MISS]) + "\n" + " " + "\n"
		info2.text += "Combo: " + str(Game.combo) + "\n"
		info2.text += "Max Combo: " + str(Game.max_combo) + "\n"
	else:
		info2.text += Setting.translate("Marvelous") +": " + str(Game.rating_total[Game.PERF]) + "\n"
		info2.text += Setting.translate("Sick") +": " + str(Game.rating_total[Game.SICK]) + "\n"
		info2.text += Setting.translate("Good") +": " + str(Game.rating_total[Game.GOOD]) + "\n"
		info2.text += Setting.translate("Bad") +": " + str(Game.rating_total[Game.BAD]) + "\n"
		info2.text += Setting.translate("Shit") +": " + str(Game.rating_total[Game.SHIT]) + "\n"
		info2.text += Setting.translate("Misses") +": " + str(Game.rating_total[Game.MISS]) + "\n \n"
		info2.text += Setting.translate("Combo") +": " + str(Game.combo) + "\n"
		info2.text += Setting.translate("Max Combo") +": " + str(Game.max_combo) + "\n"
	


func fc_state_check():
	var fc_state: String
	if Game.health == 0 or Game.fc_state == "Failed":
		fc_state = "- Failed"
		return fc_state
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

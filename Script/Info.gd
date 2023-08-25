extends CanvasLayer

var last_hit = 0
var stop := false

@onready var info1 = $ScoreTxt/Label1
@onready var info2 = $Label2
@onready var info3 = $Label3
@onready var info4 = $Label4
@onready var ratinginfo = $RatingTxt
@onready var num = $Num
@onready var kpsinfo = $KPS
@onready var dad_kpsinfo = $DADKPS

var adam_conditions: Array = [["Perfect!!", "PFC"], ["Sick!", 1.0], ["Great", 0.9], ["Good", 0.8],
 ["Nice", 0.7], ["Meh", 0.69], ["Bruh", 0.6], ["Bad", 0.5], ["Shit", 0.4], ["You Suck!", 0.2]]

var strident_conditions := [["Haxxer!!", "PFC"], ["Cheater!", 1.0], ["Great", 0.9], ["Good", 0.8],
["Eh", 0.7], ["Ok", 0.6], ["It\'s not overcharted, you\'re just bad.", 0.5], ["Done For.", 0.4],
["Cope Harder", 0.2]]

var kade_rank := [["AAAAA", 1.0], ["AAAA:", 0.9999], ["AAAA.", 0.99975],
["AAAA", 0.9996], ["AAA:", 0.9991], ["AAA.", 0.998], ["AAA", 0.9975],
["AA:", 0.996], ["AA.", 0.97], ["AA", 0.93], ["A:", 0.9], ["A.", 0.85],
["A", 0.8], ["B", 0.7], ["C", 0.6], ["D", 0.0]]

var denpa_rank := [["X", "MFC"], ["S", 1.0], ["A", 0.9], ["B", 0.8],
["Nice", 0.7], ["C", 0.69], ["D", 0.5], ["E", 0.4], ["F", 0.2], ["How?", 0.0]]

var adam_fc := [["MFC", "marv"], ["SFC", "sick"], ["GFC", "good"], ["FC", "badshit"],
["SDCB", "miss", 1], ["Clear", "miss", 10], ["Failed", "fail"]]

var psych_fc := [["SFC", "marvsick"], ["GFC", "good"], ["FC", "badshit"],
["SDCB", "miss", 1], ["Clear", "miss", 10], ["Failed", "fail"]]

var leather_fc := [["MFC", "marv"], ["SDP", "sick"], ["SDG", "good"], ["SDB", "bad"],
["FC", "shit"], ["SDCB", "miss", 1], ["Clear", "miss", 10]]

var denpa_fc := [["SFC", "marvsick"], ["GFC", "good"], ["FC", "badshit"],
["SDCB", "miss", 1], ["DDCB", "miss", 10], ["TDCB", "miss", 100]]

func _ready():
	await Modchart.modchart_ready
	if not Setting.s_get("gameplay", "downscroll"):
		info1.position.y = 600
	
	if Setting.engine() == "other a":
		Game.rating_name = ["Marvelous!!", "Sick!", "Good", "Bad", "Shit", "Miss"]
	
	Setting.set_dfont_mini(info1)
	Setting.set_dfont_mini(info2)
	Setting.set_dfont_mini(info4)
	Setting.set_dfont_mini(info4.get_node("Difficulty"))
	info4.add_theme_color_override("font_outline_color", "black")
	info4.add_theme_color_override("font_shadow_color", "black")
	info4.get_node("Difficulty").add_theme_color_override("font_outline_color", "black")
	info4.get_node("Difficulty").add_theme_color_override("font_shadow_color", "black")
	if Setting.jpn():
		info4.get_node("Difficulty").position.x -= 10
	
	updateComboInfo()
	
	var lower = Game.cur_song.to_lower()
	if Game.cur_song.to_lower() == lower:
		info4.text = Game.cur_song[0].to_upper() + Game.cur_song.substr(1) + " - "
	else:
		info4.text = Game.cur_song[0] + " - "
	info4.get_node("Difficulty").text = Setting.translate(Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1))
	info4.get_node("Difficulty").add_theme_color_override("font_color", Game.difficulty_color[Game.cur_diff])
	
	var info_data = generate_info_text("N/A")
	info1.text = info_data[0]
	info1.add_theme_font_size_override("font_size", info_data[1])
	info1.add_theme_constant_override("outline_size", info_data[2])
	
	await get_tree().create_timer(0.26).timeout
	updateComboInfo()

func updatePos():
	if not Setting.s_get("gameplay", "downscroll"):
		info1.position.y = 600
	else:
		info1.position.y = 129

func generate_info_text(score, miss = 0, rating = "", acc = "", fc = "", rank = "", nps = 0):
	var get = Setting.engine()
	var limit: String
	var scoreTxt := "Score"
	var missTxt := "Misses"
	var accTxt := "Accuracy"
	var ratingTxt := "Rating"
	var npsTxt := "NPS"
	var sp = ": "
	var sp2 = " | "
	var sp3 = " - "
	var sp4 = " ("
	var sp5 = "%)"
	var text_size = 20
	var outline_size = 5
	var unknown := false
	if score is String:
		score = 0
		sp3 = ""
		sp4 = ""
		sp5 = ""
		rating = "?"
		unknown = true
	if Modchart.mGet("defeat", 2):
		limit = " / " + str(Modchart.mGet("defeat", 0) - 1)
	if Setting.jpn():
		missTxt = "Miss"
		ratingTxt = "Rank"
	if get == "adam":
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + ratingTxt + sp + rating + sp4 + str(acc) + sp5 + sp3 + fc, text_size, outline_size]
	elif get == "psych":
		outline_size = 6
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + ratingTxt + sp + rating + sp4 + str(acc) + sp5 + sp3 + fc, text_size, outline_size]
	elif get == "kade1.2":
		sp = ":"
		sp3 = " | "
		sp5 = "%"
		text_size = 16
		outline_size = 4
		if unknown:
			acc = 0
			fc = "FC"
		else:
			if acc >= 97.5:
				fc = "FC"
			elif acc >= 75.0:
				sp3 = ""
				fc = ""
			else:
				fc = "BAD"
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + accTxt + sp + str(acc) + sp5 + sp3 + fc, text_size, outline_size]
	elif get == "kade1.4":
		var npsText = npsTxt + sp + str(ceil(nps)) + sp2
		missTxt = "Combo Breaks"
		sp = ":"
		sp3 = "("
		sp4 = ") "
		sp5 = "%"
		text_size = 16
		outline_size = 4
		if unknown:
			acc = 0
			fc = "N/A"
			sp3 = ""
			sp4 = ""
		if not Setting.s_get("graphics", "show kps"):
			npsText = ""
		return [npsText + scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + accTxt + sp + str(acc) + sp5 + sp2 + sp3 + fc + sp4 + rank, text_size, outline_size]
	elif get == "kade1.8":
		var npsText = npsTxt + sp + str(ceil(nps)) + " (Max " + str(ceil(Game.max_nps)) + ")" + sp2
		missTxt = "Combo Breaks"
		sp = ":"
		sp3 = "("
		sp4 = ") "
		sp5 = " %"
		text_size = 16
		outline_size = 4
		if unknown:
			acc = 0
			fc = "N/A"
			sp3 = ""
			sp4 = ""
		if not Setting.s_get("graphics", "show kps"):
			npsText = ""
		return [npsText + scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + accTxt + sp + str(acc) + sp5 + sp2 + sp3 + fc + sp4 + rank, text_size, outline_size]
	elif get == "leather":
		sp5 = "%"
		text_size = 16
		outline_size = 3
		if unknown:
			acc = 100
			fc = "MFC"
			rank = "SSSS"
			sp3 = " - "
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + accTxt + sp + str(acc) + sp5 + sp2 + fc + sp3 + rank, text_size, outline_size]
	elif get == "denpa":
		missTxt = "Breaks"
		text_size = 21
		if unknown:
			rating = "Unrated"
			acc = ""
			fc = ""
			sp3 = ""
			sp4 = ""
			sp5 = ""
		outline_size = 6
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + ratingTxt + sp + rating + sp4 + str(acc) + sp5 + sp3 + fc, text_size, outline_size]
	elif get == "other a":
		sp2 = " • "
		sp3 = " ~ "
		sp4 = " ["
		sp5 = "%]"
		if unknown:
			acc = ""
			fc = ""
			sp3 = ""
			sp4 = ""
			sp5 = ""
		outline_size = 6
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + ratingTxt + sp + rating + sp4 + str(acc) + sp5 + sp3 + fc, text_size, outline_size]
	elif get == "other b":
		missTxt = "Phone Breaks"
		Setting.set_dfont_strident(info1)
		Setting.set_dfont_strident(info2)
		Setting.set_dfont_strident(info3)
		Setting.set_dfont_strident(info4)
		info4.modulate.a = 0.5
		if Game.cur_state == Game.COUNTDOWN:
			info4.get_node("Difficulty").hide()
			info4.text += Game.cur_diff[0].to_upper() + Game.cur_diff.substr(1)
		info3.position.y = 680
		info4.position.y = 690
		return [scoreTxt + sp + str(score) + sp2 + missTxt + sp + str(miss) + limit + sp2 + ratingTxt + sp + rating + sp4 + str(acc) + sp5 + sp3 + fc, text_size, outline_size]

var beat := 0
var rating_timer := 0.0

func _process(delta):
	rating_timer -= delta
	ratinginfo.modulate = lerp(ratinginfo.modulate, Color(1, 1, 1, ratinginfo.modulate.a), 0.1)
	num.modulate = ratinginfo.modulate
	if rating_timer <= 0.0 and ratinginfo.visible:
		var rand1 = char(randi_range(65, 90))
		var rand2 = char(randi_range(65, 90))
		var rand3 = char(randi_range(65, 90))
		var rand4 = char(randi_range(65, 90))
		ratinginfo.text = rand1 + rand2 + rand3 + rand4
		num.text = str(randi_range(100, 999))
		ratinginfo.modulate.a -= delta * 2
		num.modulate.a -= delta * 2
	if Game.cur_diff == "voiid":
		if beat != Audio.cur_beat:
			beat = Audio.cur_beat
			info4.get_node("Difficulty").modulate.v = 2.0
		info4.get_node("Difficulty").modulate.v = lerp(info4.get_node("Difficulty").modulate.v, 1.0, 0.1)
	
	var total := 0.0
	var total2 := 0.0
	var total3 := 0.0
	if Setting.s_get("graphics", "show kps"):
		if !kpsinfo.visible:
			kpsinfo.show()
			dad_kpsinfo.show()
		
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
		
		var count2 := 0
		for i in Game.nps.size():
			if Game.nps[count2] < 0.0:
				Game.nps.remove_at(count2)
				if Game.nps.size() != 0:
					count2 -= 1
				else:
					break
			total2 += Game.nps[count2]
			Game.nps[count2] -= delta
			count2 += 1
		if total2 < 0.0:
			total2 = 0.0
		if total2 >= Game.max_nps:
			Game.max_nps = total2
		
		var count3 := 0
		for i in Game.dad_kps.size():
			if Game.dad_kps[count3] < 0.0:
				Game.dad_kps.remove_at(count3)
				if Game.dad_kps.size() != 0:
					count3 -= 1
				else:
					break
			total3 += Game.dad_kps[count3]
			Game.dad_kps[count3] -= delta
			count3 += 1
		if total3 < 0.0:
			total3 = 0.0
		
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

		dad_kpsinfo.text = str("%0.2f" % total3)
		if total3 >= 0:
			dad_kpsinfo.add_theme_color_override("font_color", Color(1 - total3 / 50, 1, 1))
		if total3 >= 10:
			dad_kpsinfo.add_theme_color_override("font_color", Color(total3 / 50 + 0.6, 1, 1 - total3 / 40))
		if total3 >= 20:
			dad_kpsinfo.add_theme_color_override("font_color", Color(1, 1 - total3 / 50, 1 - total3 / 40))
		if total3 >= 30:
			dad_kpsinfo.add_theme_color_override("font_color", Color(1, 1 - total3 / 50, 1 - total3 / 40))
		if total3 >= 40:
			dad_kpsinfo.add_theme_color_override("font_color", Color(1, 0, 1 - 40 / total3))
	info1.scale = lerp(info1.scale, Vector2(1, 1), 0.1)
	if last_hit != Game.hit:
		if Setting.engine() == "other a":
			if Game.rating_name.find(Game.cur_rating) == Game.MISS:
				ratinginfo.modulate = Color(1, 0, 0)
				ratinginfo.text = "Miss"
			elif Game.rating_name.find(Game.cur_rating) == Game.PERF:
				ratinginfo.modulate = Color(1, 1, 0)
				ratinginfo.text = "Sick!"
			else:
				ratinginfo.text = Game.cur_rating
			rating_timer = 1.0
			ratinginfo.show()
			num.show()
			ratinginfo.modulate.a = 1.0
			num.modulate.a = 1.0
			num.text = "%03d" % Game.combo
		last_hit = Game.hit
		info1.scale = Vector2(1.2, 1.2)
	if Game.hit >= 1 and not stop:#if last_hit != Game.hit:
		var fc_state: String = fc_state_check()
		var rating_text: String = rating_text_check()
		var rank: String = rank_check()
		
		var info_data = generate_info_text(Game.score, Game.rating_total[Game.MISS], Setting.translate(rating_text), floor(Game.accuracy * 10000.0) / 100.0, fc_state, rank, total2)
		info1.text = info_data[0]
		
		info1.add_theme_font_size_override("font_size", info_data[1])
		info1.add_theme_constant_override("outline_size", info_data[2])
		
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
	var list = adam_fc
	var engine = Setting.engine()
	if engine == "leather":
		list = leather_fc
	elif engine == "psych":
		list = psych_fc
	elif engine == "denpa":
		list = denpa_fc
	for i in list:
		if i[1] == "fail":
			if Game.health == 0 or Game.fc_state == "Failed":
				Game.fc_state = i[0]
				break
		elif i[1] == "marv":
			if Game.rating_total[Game.PERF] > 0:
				Game.fc_state = i[0]
		elif i[1] == "sick":
			if Game.rating_total[Game.SICK] > 0:
				Game.fc_state = i[0]
		elif i[1] == "marvsick":
			if Game.rating_total[Game.PERF] > 0 or Game.rating_total[Game.SICK] > 0:
				Game.fc_state = i[0]
		elif i[1] == "good":
			if Game.rating_total[Game.GOOD] > 0:
				Game.fc_state = i[0]
		elif i[1] == "bad":
			if Game.rating_total[Game.BAD] > 0:
				Game.fc_state = i[0]
		elif i[1] == "badshit":
			if Game.rating_total[Game.BAD] > 0 or Game.rating_total[Game.SHIT] > 0:
				Game.fc_state = i[0]
		elif i[1] == "shit":
			if Game.rating_total[Game.SHIT] > 0:
				Game.fc_state = i[0]
		elif i[1] == "miss":
			if Game.rating_total[Game.MISS] >= i[2]:
				Game.fc_state = i[0]
	return Game.fc_state

func rating_text_check():
	var rating_text: String
	var conditions = adam_conditions
	var engine = Setting.engine()
	if engine == "denpa":
		conditions = denpa_rank
	elif engine == "other b":
		conditions = strident_conditions
	for i in conditions:
		if i[1] is String:
			if i[1] == "PFC":
				if Game.fc_state == "MFC" or Game.fc_state == "SFC":
					rating_text = i[0]
					break
			elif i[1] == "MFC":
				if Game.fc_state == "MFC":
					rating_text = i[0]
					break
		else:
			if i[1] >= Game.accuracy:
				rating_text = i[0]
	return Setting.translate(rating_text)

func rank_check():
	var rank_text: String
	for i in kade_rank:
		if i[1] is String:
			if i[1] == "PFC":
				if Game.fc_state == "MFC" or Game.fc_state == "SFC":
					rank_text = i[0]
					break
		else:
			if i[1] >= Game.accuracy:
				rank_text = i[0]
	return rank_text

func stopUpdateText():
	stop = true

func resumeUpdateText():
	stop = false

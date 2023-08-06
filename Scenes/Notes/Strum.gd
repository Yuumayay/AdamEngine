extends AnimatedSprite2D

signal bf_hit

@export var dir: int

enum {AUTO_DAD, PLAYER, AUTO_PLAYER}
@export var type: int

var rating = preload("res://Scenes/Rating.tscn")
var splash_path = "res://Assets/Images/Notes/Default/Note_Splashes.xml"
var hit: String

func _ready():
	hit = Setting.setting.category["gameplay"]["hit sound"]["metadata"][Setting.s_get("gameplay", "hit sound")]
	Audio.a_volume_set(hit, 10)
	if Game.note_anim[dir - type * Game.key_count].contains("2"):
		animation = Game.note_anim[dir - type * Game.key_count].replace("2", "") + " static"
	else:
		animation = Game.note_anim[dir - type * Game.key_count] + " static"
	var splash = Game.load_XMLSprite(splash_path, "", false)
	splash.name = "splash"
	splash.modulate.a = 0
	splash.scale = Vector2(2, 2)
	splash.position.x += 50
	add_child(splash)
	
func _process(delta):
	if Game.cur_state == Game.NOT_PLAYING: return
	
	$splash.modulate.a -= delta * 5
		
	if type == AUTO_DAD:
		bot_strum()
		strum_anim_dad()
	elif type == PLAYER:
		player_strum()
		strum_anim_player()
	elif type == AUTO_PLAYER:
		playerbot_strum()
		strum_anim_player()

func hide_note(i):
	# 消去フラグをオンにして、ノートを非表示
	i.free_f = true
	i.visible = false

func calc_sus_time(note):
	# susの残り時間を計算（マイナス）
	var elapsed =  Audio.cur_ms - note.ms # 経過した長押し時間
	var remain_sus = note.sus - elapsed
	
	return remain_sus
	#return Audio.cur_ms - note.ms - note.sus + Game.sus_tolerance

func strum_anim_player():
	if Game.cur_input[dir - type * Game.key_count] == 0:
		if Game.note_anim[dir - type * Game.key_count].contains("2"):
			animation = Game.note_anim[dir - type * Game.key_count].replace("2", "") + " static"
		else:
			animation = Game.note_anim[dir - type * Game.key_count] + " static"
	else:
		if animation.contains("confirm"):
			frame += 1
		else:
			if type == PLAYER:
				animation = Game.note_anim[dir - type * Game.key_count] + " press"

func strum_anim_dad():
	if Game.dad_input[dir] == 0:
		if Game.note_anim[dir].contains("2"):
			animation = Game.note_anim[dir].replace("2", "") + " static"
		else:
			animation = Game.note_anim[dir] + " static"
	else:
		if animation.contains("confirm"):
			frame += 1

func bot_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		var msdiff = Audio.cur_ms - i.ms
		if msdiff < -1*Game.get_preload_sec()*1000:
			continue
					
		# strumを通りすぎたとき (現在の曲のmsがノーツのmsを超えた）
		if Audio.cur_ms >= i.ms:
			if i.sus == 0: # 単押しだったら
				animation = Game.note_anim[dir] + " confirm"
				Audio.a_volume_set("Voices", 0)
				Game.dad_input[dir] = 2
				hide_note(i)
				dad_hit()
			else: # 長押しだったら
				# ノーツだけを透明にし、長押しラインのポイント0の位置をstrumに合わさるように変える
				if i.self_modulate.a != 0:
					animation = Game.note_anim[dir] + " confirm"
					Audio.a_volume_set("Voices", 0)
					Game.dad_input[dir] = 2
					i.self_modulate.a = 0
					dad_hit()
					break
				Game.dad_input[dir] = 1
				i.update_linelen()
				
				if calc_sus_time(i) <= 0:
					Game.dad_input[dir] = 0
					hide_note(i)

func playerbot_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		var msdiff = Audio.cur_ms - i.ms
		if msdiff < -1*Game.get_preload_sec()*1000:
			continue
					
		if Audio.cur_ms >= i.ms:
			if i.sus == 0:# 単押しだったら
				animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
				Game.cur_input[dir - type * Game.key_count] = 2
				hide_note(i)
				i.hit_ms = 0.0
				Game.kps.append(1.0)
				judge(i.hit_ms, i.type)
			else:# 長押しだったら
				if i.self_modulate.a != 0:
					animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
					Game.cur_input[dir - type * Game.key_count] = 2
					i.self_modulate.a = 0
					i.hit_ms = 0.0
					Game.kps.append(1.0)
					judge(i.hit_ms, i.type)
					break
				Game.cur_input[dir - type * Game.key_count] = 1
				i.update_linelen()
				if calc_sus_time(i) <= 0:
					Game.cur_input[dir - type * Game.key_count] = 0
					hide_note(i)

func player_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		var msdiff = Audio.cur_ms - i.ms
		if msdiff < -1*Game.get_preload_sec()*1000:
			continue
		
		if Audio.cur_ms >= i.ms - Game.rating_offset[Game.MISS] * Game.cur_multi:
			if i.sus == 0:
				if Game.cur_input[dir - type * Game.key_count] == 2:
					animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
					hide_note(i)
					i.hit_ms = msdiff / Game.cur_multi
					judge(i.hit_ms, i.type)
					break
				if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS] * Game.cur_multi:
					i.free_f = true
					i.modulate.a = 0.5
			else:
				if i.self_modulate.a == 0:
					if Game.cur_input[dir - type * Game.key_count] == 1:
						i.self_modulate.a = 0
						if msdiff >= 0:
							i.update_linelen()
							
						if calc_sus_time(i) <= 0:
							# プレイヤーが最後までキーを押しっぱなしならOK　（FNFではOK
							hide_note(i)
							
					else: #長押し状態からキーが離された。
						if calc_sus_time(i) - Game.sus_tolerance * Game.cur_multi <= 0:
							# プレイヤーは猶予時間内までに離されたら特別にOK
							hide_note(i)
						else: #早く離しすぎ
							i.free_f = true
							i.modulate.a = 0.5
				else:
					if Game.cur_input[dir - type * Game.key_count] == 2:
						animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
						i.self_modulate.a = 0
						i.hit_ms = msdiff / Game.cur_multi
						judge(i.hit_ms, i.type)
						break
					if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS] * Game.cur_multi:
						i.free_f = true
						i.modulate.a = 0.5

func judge(hit_ms, notetype):
	emit_signal("bf_hit")
	
	var ms = abs(hit_ms)
	var layer = rating.instantiate()
	var new_rating = layer.get_node("Rating")
	
	Audio.a_volume_set("Voices", 0)
	Audio.a_play(hit, 1.0, Setting.s_get("gameplay", "hit sound volume") * 0.5 - 50)
	
	Game.bf_hit_bool = true
	if Setting.eng():
		new_rating.animation = "ratings"
	elif Setting.jpn():
		new_rating.animation = "ratingsJP"
	if notetype == 4:
		Audio.a_play("Loss Shaggy")
		Game.add_rating(Game.MISS)
		Game.add_health(-999)
		Game.add_score(Game.score_gain[Game.MISS])
	elif ms <= Game.rating_offset[Game.PERF + 1]:
		$splash.modulate.a = 1
		$splash.stop()
		$splash.play("note splash " + Game.note_anim[dir - Game.key_count])
		new_rating.frame = Game.PERF
		Game.add_rating(Game.PERF)
		Game.add_health(Game.health_gain[Game.PERF])
		Game.add_score(Game.score_gain[Game.PERF])
	elif ms <= Game.rating_offset[Game.SICK + 1]:
		$splash.modulate.a = 1
		$splash.stop()
		$splash.play("note splash " + Game.note_anim[dir - Game.key_count])
		new_rating.frame = Game.SICK
		Game.add_rating(Game.SICK)
		Game.add_health(Game.health_gain[Game.SICK])
		Game.add_score(Game.score_gain[Game.SICK])
	elif ms <= Game.rating_offset[Game.GOOD + 1]:
		new_rating.frame = Game.GOOD
		Game.add_rating(Game.GOOD)
		Game.add_health(Game.health_gain[Game.GOOD])
		Game.add_score(Game.score_gain[Game.GOOD])
	elif ms <= Game.rating_offset[Game.BAD + 1]:
		new_rating.frame = Game.BAD
		Game.add_rating(Game.BAD)
		Game.add_health(Game.health_gain[Game.BAD])
		Game.add_score(Game.score_gain[Game.BAD])
	elif ms <= Game.rating_offset[Game.SHIT + 1]:
		new_rating.frame = Game.SHIT
		Game.add_rating(Game.SHIT)
		Game.add_health(Game.health_gain[Game.SHIT])
		Game.add_score(Game.score_gain[Game.SHIT])
	else:
		Audio.a_stop(hit)
		Game.bf_hit_bool = false
		return
	
	var mstext = layer.get_node("Label")
	mstext.ms = hit_ms
	
	$/root.add_child(layer)

func dad_hit():
	if Modchart.modcharts.has("healthDrain"):
		if Game.health - Modchart.modcharts.healthDrain[0] >= Modchart.modcharts.healthDrain[1]:
			Game.add_health(-Modchart.modcharts.healthDrain[0])

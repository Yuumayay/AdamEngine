extends AnimatedSprite2D

signal bf_hit

@export var dir: int # fnfdir 0,1,2,3  ,4...

enum {AUTO_DAD, PLAYER, AUTO_PLAYER, GF}
@export var type: int

var rating = preload("res://Scenes/Rating.tscn")
var hit: String
var ndir := 0 # dir
var keys_anim : Array 
var kc := 0

func _ready():
	hit = Setting.setting.category["gameplay"]["hit sound"]["metadata"][Setting.s_get("gameplay", "hit sound")]
	Audio.a_volume_set(hit, 10)
	
	ndir = dir
	if type == PLAYER or type == AUTO_PLAYER: #bf strum
		kc = Game.KC_BF
		ndir -= Game.key_count[Game.KC_DAD]
	elif type == AUTO_DAD: # dad strum
		kc = Game.KC_DAD
	elif type == GF: # gf strum
		kc = Game.KC_GF
		ndir -= Game.key_count[Game.KC_DAD]
	
	if Game.key_count[kc] > 18:
		var n = kc / 18
		var n2 = kc % 18
		for i in n:
			keys_anim.append_array(View.keys["18k"])
		if n2 != 0:
			keys_anim.append_array(View.keys[str(n2) + "k"])
	else:
		keys_anim = View.keys[str(Game.key_count[kc]) + "k"]
	
	if keys_anim[ndir].contains("2"):
		animation = keys_anim[ndir].replace("2", "") + " static"
	else:
		animation = keys_anim[ndir] + " static"
	var splash = AnimatedSprite2D.new()
	splash.sprite_frames = View.splashSpriteFrames
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
	elif type == GF:
		bot_strum()
		strum_anim_dad()

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
	if Game.cur_input[ndir] == 0:
		if keys_anim[ndir].contains("2"):
			animation = keys_anim[ndir].replace("2", "") + " static"
		else:
			animation = keys_anim[ndir] + " static"
	else:
		if animation.contains("confirm"):
			frame += 1
		else:
			if type == PLAYER:
				animation = keys_anim[ndir] + " press"

func strum_anim_dad():
	var input: Array
	if type == AUTO_DAD:
		input = Game.dad_input
	elif type == GF:
		input = Game.gf_input
	if input[dir] == 0:
		if keys_anim[dir].contains("2"):
			animation = keys_anim[dir].replace("2", "") + " static"
		else:
			animation = keys_anim[dir] + " static"
	else:
		if animation.contains("confirm"):
			frame += 1

func bot_strum():
	var input: Array
	var pType: int
	if type == AUTO_DAD:
		input = Game.dad_input
		pType = 0
	elif type == GF:
		input = Game.gf_input
		pType = 2
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir or i.player != pType:
			continue
		var msdiff = Audio.cur_ms - i.ms
		if msdiff < -1*Game.get_preload_sec()*1000:
			continue
					
		# strumを通りすぎたとき (現在の曲のmsがノーツのmsを超えた）
		if Audio.cur_ms >= i.ms:
			if i.sus == 0: # 単押しだったら
				animation = keys_anim[dir] + " confirm"
				Audio.a_volume_set("Voices", 0)
				input[dir] = 2
				hide_note(i)
				dad_hit()
			else: # 長押しだったら
				# ノーツだけを透明にし、長押しラインのポイント0の位置をstrumに合わさるように変える
				if i.self_modulate.a != 0:
					animation = keys_anim[dir] + " confirm"
					Audio.a_volume_set("Voices", 0)
					input[dir] = 2
					i.self_modulate.a = 0
					dad_hit()
					break
				input[dir] = 1
				i.update_linelen()
				
				if calc_sus_time(i) <= 0:
					input[dir] = 0
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
				animation = keys_anim[ndir] + " confirm"
				Game.cur_input[ndir] = 2
				hide_note(i)
				i.hit_ms = 0.0
				Game.kps.append(1.0)
				judge(i.hit_ms, i.type)
			else:# 長押しだったら
				if i.self_modulate.a != 0:
					animation = keys_anim[ndir] + " confirm"
					Game.cur_input[ndir] = 2
					i.self_modulate.a = 0
					i.hit_ms = 0.0
					Game.kps.append(1.0)
					judge(i.hit_ms, i.type)
					break
				Game.cur_input[ndir] = 1
				i.update_linelen()
				if calc_sus_time(i) <= 0:
					Game.cur_input[ndir] = 0
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
				if Game.cur_input[ndir] == 2:
					animation = keys_anim[ndir] + " confirm"
					hide_note(i)
					i.hit_ms = msdiff / Game.cur_multi
					judge(i.hit_ms, i.type)
					break
				if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS] * Game.cur_multi:
					i.free_f = true
					i.modulate.a = 0.5
			else:
				if i.self_modulate.a == 0:
					if Game.cur_input[ndir] == 1:
						i.self_modulate.a = 0
						Game.add_health(Game.health_gain[Game.LONG_NOTE])
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
					if Game.cur_input[ndir] == 2:
						animation = keys_anim[ndir] + " confirm"
						i.self_modulate.a = 0
						i.hit_ms = msdiff / Game.cur_multi
						judge(i.hit_ms, i.type)
						break
					if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS] * Game.cur_multi:
						i.free_f = true
						i.modulate.a = 0.5

func judge(hit_ms, notetype):
	emit_signal("bf_hit")
	
	if Modchart.has_goodNoteHit:
		Modchart.mNode.call("goodNoteHit")
	
	var ms = abs(hit_ms)
	var layer = rating.instantiate()
	var new_rating = layer.get_node("Rating")
	
	Game.nps.append(1.0)
	
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
		$splash.play("note splash " + keys_anim[ndir])
		new_rating.frame = Game.PERF
		Game.add_rating(Game.PERF)
		Game.add_health(Game.health_gain[Game.PERF])
		Game.add_score(Game.score_gain[Game.PERF])
	elif ms <= Game.rating_offset[Game.SICK + 1]:
		$splash.modulate.a = 1
		$splash.stop()
		$splash.play("note splash " + keys_anim[ndir])
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
	Game.dad_kps.append(1.0)
	if Modchart.has_opponentNoteHit:
		Modchart.mNode.call("opponentNoteHit")
	if Modchart.modcharts.has("healthDrain"):
		if Game.health - Modchart.modcharts.healthDrain[0] >= Modchart.modcharts.healthDrain[1]:
			Game.add_health(-Modchart.modcharts.healthDrain[0])

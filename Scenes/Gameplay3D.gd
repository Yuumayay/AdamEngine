#
# fxxkin shit copy code
# 3D mode

extends Node3D

@onready var strum_group: CanvasLayer = get_node("Strums")
@onready var note_group: CanvasLayer = get_node("Notes")
@onready var gameover: CanvasLayer = $Gameover

var note_count: int
var cam_zoom: float = 1
var timer: Timer = Timer.new()
var countDownTimer: Timer = Timer.new()

var pause = preload("res://Scenes/Pause Menu.tscn")

var countdowns: Array = [preload("Assets/Images/Skins/FNF/Countdown/ready.png"),
preload("Assets/Images/Skins/FNF/Countdown/set.png"),
preload("Assets/Images/Skins/FNF/Countdown/go.png")]

func _ready():
	timer.name = "timer"
	countDownTimer.name = "countDownTimer"
	
	Audio.a_stop("Freaky Menu")
	var song_data = File.f_read(Paths.p_chart(Game.cur_song, Game.cur_diff), ".json")
	Game.setup(song_data)
	
	cam_zoom = Game.defaultZoom
	$Camera.fov = cam_zoom * 75
	
	if Paths.p_song(Game.cur_song, "Voices"):
		Audio.a_set("Voices", Paths.p_song(Game.cur_song, "Voices"), Audio.bpm)
	else:
		Audio.a_set("Voices", "", Audio.bpm)
	Audio.a_set("Inst", Paths.p_song(Game.cur_song, "Inst"), Audio.bpm)
	
	keybind(Game.key_count)
	strum_set()
	character_set()
	#note_set()
	countdown()
	Modchart.loadModchart()
	modchartCheck()

var beatCount := 5

func _process(delta):
	# enum {NOT_PLAYING, COUNTDOWN, PLAYING, PAUSE, GAMEOVER}
	if Game.cur_state == Game.NOT_PLAYING: return
	
	gameoverCheck()
	scoreSaveCheck()
	
	if !Game.spawn_end:
		if Game.cur_state == Game.COUNTDOWN:
			Audio.beat_hit_bool = false
			Audio.beat_hit_event = false

			Audio.cur_ms = timer.time_left * -1000 + delta * 1000
			if Audio.cur_ms >= (60.0 / Audio.bpm) * beatCount * -1000:
				beatCount -= 1
				Audio.beat_hit_bool = true
				Audio.beat_hit_event = true
		
		for i in range(20000):
			if Game.spawn_end or !(Game.ms[note_count] - Game.get_preload_sec() * 1000 <= Audio.cur_ms):
				break
			note_spawn_load()
	else:  #Game.spawn_end
		if !Audio.a_check("Inst") and Game.cur_state != Game.PAUSE and Game.cur_state != Game.GAMEOVER:
			if Game.is_story:
				Game.cur_song_index += 1
				Game.week_fc_state.append(Game.fc_state)
				if Game.cur_song_index < Game.songList.size():
					scoreSave("freeplay", Game.songList[Game.cur_song_index])
					moveSong(Game.songList[Game.cur_song_index])
				else:
					Game.is_story = false
					
					scoreSave("story", Game.cur_week)
					
					quitStory()
			else:
				scoreSave("freeplay", Game.cur_song)
				
				quit()
	
	if Game.cur_state == Game.PLAYING or Game.cur_state == Game.COUNTDOWN: #プレイ中だったら
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_stop("Inst")
			Audio.a_stop("Voices")
			quit()
		if Input.is_action_just_pressed("game_pause"):
			Game.cur_state = Game.PAUSE
			if timer:
				timer.paused = true
				countDownTimer.paused = true
			add_child(pause.instantiate())
			Audio.a_pause("Inst")
			Audio.a_pause("Voices")
	elif Game.cur_state == Game.GAMEOVER: #ゲームオーバーだったら
		if Input.is_action_just_pressed("ui_cancel"):
			if Audio.a_check("Gameover"):
				Audio.a_stop("Gameover")
			if Audio.a_check("GameoverStart"):
				Audio.a_stop("GameoverStart")
			if Audio.a_check("GameoverEnd"):
				Audio.a_stop("GameoverEnd")
			quit()
		if Input.is_action_just_pressed("ui_accept"):
			gameover.accepted()

func scoreSave(case: String, song_or_week: String):
	if Game.saveScore:
		if case == "freeplay":
				var json: Dictionary = File.f_read("user://ae_score_data.json", ".json")
				var songpath = song_or_week.to_lower() + "-" + Game.cur_diff
				var scorejson: Dictionary = {
					songpath: {
						"score": 0,
						"fc_state": 0,
						"accuracy": 0
					}
				}
				if not json.song.has(songpath):
					json.song.append(scorejson)
				for i in json.song:
					if i.has(songpath):
						if i[songpath].score < Game.score:
							i[songpath].score = Game.score
							i[songpath].fc_state = Game.fc_state
							i[songpath].accuracy = floor(Game.accuracy * 10000.0) / 100.0
							File.f_save("user://ae_score_data", ".json", json)
						else:
							print("not high score")
						break
				print(json)
		elif case == "story":
				var json: Dictionary = File.f_read("user://ae_week_score_data.json", ".json")
				var songpath = song_or_week.to_lower() + "-" + Game.cur_diff
				var scorejson: Dictionary = {
					songpath: {
						"score": 0,
						"fc_state": 0,
						"accuracy": 0
					}
				}
				if not json.week.has(songpath):
					json.week.append(scorejson)
				for i in json.week:
					if i.has(songpath):
						if i[songpath].score < Game.week_score:
							i[songpath].score = Game.week_score
							i[songpath].fc_state = Game.week_fc_state
							i[songpath].accuracy = floor(Game.week_accuracy * 10000.0) / 100.0
							File.f_save("user://ae_week_score_data", ".json", json)
						else:
							print("not high score")
						break
				print(json)

func killBF():
	if Game.cur_state == Game.COUNTDOWN:
		timer.stop()
		countDownTimer.stop()
	gameover.gameover()

func gameoverCheck():
	if Game.cur_state != Game.GAMEOVER:
		if Modchart.mGet("defeat"):
			var missCount = Game.rating_total[Game.MISS]
			
			if not Modchart.mGet("defeat", 1):
				missCount += Game.rating_total[Game.SHIT]
			
			if missCount >= Modchart.mGet("defeat", 0):
				killBF()
			
		elif Game.health <= 0:
			Game.fc_state = "Failed"
			
			if not Setting.s_get("gameplay", "practice"):
				killBF()
				
		if Input.is_action_just_pressed("game_reset"):
			if Game.cur_state == Game.NOT_PLAYING or Game.cur_state == Game.PAUSE: return
			killBF()

func modchartCheck():
	if Modchart.modcharts.has("middleScroll"):
		var strumCount := 0
		for i in strum_group.get_children():
			if strumCount < Game.key_count:
				i.position = Vector2(-9999, 550)
				View.strum_pos[strumCount] = Vector2(-9999, 550)
			else:
				i.position.x = 115.0 * (4.0 / Game.key_count) * strumCount + 10
				View.strum_pos[strumCount].x = 115.0 * (4.0 / Game.key_count) * strumCount + 10
			strumCount += 1

func scoreSaveCheck():
	if Setting.s_get("gameplay", "botplay"):
		Game.saveScore = false
	elif Setting.s_get("gameplay", "practice"):
		Game.saveScore = false
	else:
		Game.saveScore = true

var note_scn = preload("res://Scenes/Notes/Note.tscn")
func note_spawn_load():
	var psec = Game.get_preload_sec()
	if Game.ms[note_count] - psec * 1000 <= Audio.cur_ms:
		var new_note = note_scn.instantiate()
		new_note.ind = note_count
		new_note.dir = Game.dir[note_count]
		new_note.ms = Game.ms[note_count]
		new_note.sus = Game.sus[note_count]
		if Setting.s_get("gameplay", "downscroll"):
			new_note.up_or_down = 1
		else:
			new_note.up_or_down = -1
		#new_note.visible = true
		if Game.dir[note_count] >= Game.key_count:
			new_note.player = 1
		note_group.add_child(new_note)
		if note_count == Game.ms.size() - 1:
			Game.spawn_end = true
		else:
			note_count += 1

#func note_spawn():
#	var psec = Game.get_preload_sec()
	
#	if Game.ms[note_count] - psec * 1000 <= Audio.cur_ms:
#		note_group.get_node(str(note_count)).visible = true
#		if note_count == Game.ms.size() - 1:
#			Game.spawn_end = true
#		else:
#			note_count += 1

func strum_set():
	if strum_group.get_child_count() != 0:
		for i in strum_group.get_children():
			strum_group.remove_child(i)
	View.strum_pos.clear()
	for i in Game.key_count * 2:
		var new_strum = load("res://Scenes/Notes/Strum.tscn").instantiate()
		new_strum.dir = i
		if Setting.s_get("gameplay", "downscroll"):
			new_strum.position = Vector2(150, 600)
		else:
			new_strum.position = Vector2(150, 120)
		new_strum.scale = Vector2(0.75 * (4.0 / Game.key_count), 0.75 * (4.0 / Game.key_count))
		if i >= Game.key_count:
			if Setting.s_get("gameplay", "botplay"):
				new_strum.type = 2
			else:
				new_strum.type = 1
			new_strum.position.x += 250.0 * (0.7 * 4.0 / Game.key_count)
		else:
			new_strum.type = 0
		new_strum.position.x += 115.0 * (4.0 / Game.key_count) * i
		View.strum_pos.append(new_strum.position)
		strum_group.add_child(new_strum)
	modchartCheck()

func note_pos_set():
	for i in Game.notes_data.notes:
		if not i or i.free_f: continue
		if Setting.s_get("gameplay", "downscroll"):
			i.up_or_down = 1
		else:
			i.up_or_down = -1
		i.posUpdate()

func character_set():
	for i in range(3):
		var character = load("res://Scenes/BF.tscn").instantiate()
		character.type = i
		$Characters.add_child(character)

#func note_set():
#	var ind := 0
#	for i in Game.dir:
#		var new_note = note_scn.instantiate()
#		new_note.ind = ind
#		new_note.dir = Game.dir[ind]
#		new_note.ms = Game.ms[ind]
#		new_note.sus = Game.sus[ind]
#		new_note.name = str(ind)
#		if Game.dir[ind] >= Game.key_count:
#			new_note.player = 1
#		note_group.add_child(new_note)
#		ind += 1

func keybind(key):
	if key <= 18:
		Setting.sub_input = Setting.keybind_default_sub[str(key) + "k"]
		Game.note_anim = View.keys[str(key) + "k"]
		if Setting.setting.category.keybind.has(str(key) + "k bind"):
			Setting.input = Setting.setting.category.keybind[str(key) + "k bind"]["cur"]
		else:
			Setting.input = Setting.keybind_default[str(key) + "k"]
	else:
		var n = floor(key / 18.0)
		var n2 = key % 18
		print(n)
		print(n2)
		for i in n:
			Game.note_anim.append_array(View.keys["18k"])
			Setting.input.append_array(Setting.keybind_default["18k"])
		if n2 != 0:
			Game.note_anim.append_array(View.keys[str(n2) + "k"])
			Setting.input.append_array(Setting.keybind_default[str(n2) + "k"])
	for i in key:
		Game.cur_input.append(0)
		Game.cur_input_sub.append(0)
		Game.dad_input.append(0)
		Game.gf_input.append(0)
		Game.bf_miss.append(0)

func countdown():
	Game.cur_state = Game.COUNTDOWN
	add_child(timer)
	timer.start((60.0 / Audio.bpm) * 5)
		
	add_child(countDownTimer)
	countDownTimer.start(60.0 / Audio.bpm)
	await countDownTimer.timeout
	Audio.a_play("Three")
	countDownTimer.start(60.0 / Audio.bpm)
	await countDownTimer.timeout
	$Countdown/Sprite.texture = countdowns[0]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("Two")
	countDownTimer.start(60.0 / Audio.bpm)
	await countDownTimer.timeout
	$Countdown/Sprite.texture = countdowns[1]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("One")
	countDownTimer.start(60.0 / Audio.bpm)
	await countDownTimer.timeout
	$Countdown/Sprite.texture = countdowns[2]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("Go")
	countDownTimer.start(60.0 / Audio.bpm)
	await timer.timeout
	start()
	
func start():
	Audio.a_play("Inst", Game.cur_multi)
	Audio.a_play("Voices", Game.cur_multi)
	Game.cur_state = Game.PLAYING

func reset_property():
	Game.score = 0
	Game.health = 1.0
	Game.health_percent = 50.0
	Game.accuracy = 0.0
	Game.total_hit = 0.0
	Game.hit = 0
	Game.combo = 0
	Game.max_combo = 0
	Game.fc_state = "N/A"
	Game.rating_total = [0,0,0,0,0,0]
	Game.iconBF = ""
	Game.iconDAD = ""
	Audio.songLength = 0

func reset_week_property():
	Game.cur_week = ""
	Game.songList = []
	Game.cur_song_index = 0
	Game.week_score = 0
	Game.week_accuracy = 0.0
	Game.week_total_hit = 0.0
	Game.week_hit = 0
	Game.week_fc_state = []
	Game.week_rating_total = [0,0,0,0,0,0]

func reset_dict_and_array():
	Game.cur_state = Game.NOT_PLAYING
	Game.spawn_end = false
	Game.notes_data.notes.clear()
	Game.ms.clear()
	Game.sus.clear()
	Game.dir.clear()
	Game.type.clear()
	Game.song_data.clear()
	Game.note_property.clear()
	Game.notes.clear()
	Game.cur_input.clear()
	Game.cur_input_sub.clear()
	Game.dad_input.clear()
	Game.gf_input.clear()
	Game.bf_miss.clear()
	Game.song_data.clear()
	Game.who_sing.clear()
	Game.who_sing_section.clear()
	View.strum_pos.clear()
	Modchart.modcharts.clear()

func quit():
	reset_dict_and_array()
	Audio.a_title()
	await Trans.t_trans("Freeplay")
	reset_property()

func quitStory():
	reset_dict_and_array()
	Audio.a_title()
	await Trans.t_trans("Story Mode")
	reset_week_property()

func moveSong(what):
	reset_dict_and_array()
	Game.cur_song = what
	var song_data = File.f_read(Paths.p_chart(Game.cur_song, Game.cur_diff), ".json")
	if song_data.song.has("is3D"):
		if song_data.song.is3D:
			Game.is3D = true
			Trans.t_trans("Gameplay3D")
		else:
			Game.is3D = false
			Trans.t_trans("Gameplay")
	else:
		Game.is3D = false
		Trans.t_trans("Gameplay")
	await get_tree().create_timer(0.25).timeout
	reset_property()

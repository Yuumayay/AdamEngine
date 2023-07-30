extends Node2D

@onready var strum_group: CanvasLayer = get_node("Strums")
@onready var note_group: CanvasLayer = get_node("Notes")

var note_count: int
var cam_zoom: float = 1
var timer: SceneTreeTimer

var pause = preload("res://Scenes/Pause Menu.tscn")

var countdowns: Array = [preload("res://Assets/Images/Skins/FNF/Countdown/ready.png"),
preload("res://Assets/Images/Skins/FNF/Countdown/set.png"),
preload("res://Assets/Images/Skins/FNF/Countdown/go.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.a_stop("Freaky Menu")
	var song_data = File.f_read(Paths.p_chart(Game.cur_song, Game.cur_diff), ".json")
	Game.setup(song_data)
	
	cam_zoom = Game.defaultZoom
	$Camera.zoom = Vector2(cam_zoom, cam_zoom)
	
	if Paths.p_song(Game.cur_song.to_lower(), "Voices"):
		Audio.a_set("Voices", Paths.p_song(Game.cur_song.to_lower(), "Voices"), Audio.bpm)
	else:
		Audio.a_set("Voices", "", Audio.bpm)
	Audio.a_set("Inst", Paths.p_song(Game.cur_song.to_lower(), "Inst"), Audio.bpm)
	
	keybind(Game.key_count)
	strum_set()
	character_set()
	#note_set()
	countdown()
	
	
func _process(_delta):
	if Game.cur_state != Game.SPAWN_END and Game.cur_state == Game.COUNTDOWN:
		if !timer:
			timer = get_tree().create_timer((60.0 / Audio.bpm) * 5)
		Audio.cur_ms = timer.time_left * -1000
	if Game.cur_state == Game.NOT_PLAYING: return
	if Game.cur_state != Game.SPAWN_END:
		for i in range(20000):
			if Game.cur_state == Game.SPAWN_END or !Game.ms[note_count] - Game.PRELOAD_SEC * 1000 <= Audio.cur_ms:
				break
			note_spawn_load()
	if Game.cur_state == Game.SPAWN_END:
		if !Audio.a_check("Inst"):
			quit()
	if Game.cur_state == Game.PLAYING or Game.cur_state == Game.SPAWN_END:
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_stop("Inst")
			Audio.a_stop("Voices")
			quit()
		if Input.is_action_just_pressed("game_pause"):
			add_child(pause.instantiate())
			Game.cur_state = Game.PAUSE
			Audio.a_pause("Inst")
			Audio.a_pause("Voices")



var note_scn = preload("res://Scenes/Notes/Note.tscn")
func note_spawn_load():
	var psec = Game.get_preload_sec()
	if Game.ms[note_count] - psec * 1000 <= Audio.cur_ms:
		var new_note = note_scn.instantiate()
		new_note.ind = note_count
		new_note.dir = Game.dir[note_count]
		new_note.ms = Game.ms[note_count]
		new_note.sus = Game.sus[note_count]
		new_note.visible = true
		if Game.dir[note_count] >= Game.key_count:
			new_note.player = 1
		note_group.add_child(new_note)
		if note_count == Game.ms.size() - 1:
			Game.cur_state = Game.SPAWN_END
		else:
			note_count += 1

func note_spawn():
	var psec = Game.get_preload_sec()
	
	if Game.ms[note_count] - psec * 1000 <= Audio.cur_ms:
		note_group.get_node(str(note_count)).visible = true
		if note_count == Game.ms.size() - 1:
			Game.cur_state = Game.SPAWN_END
		else:
			note_count += 1

func strum_set():
	for i in Game.key_count * 2:
		var new_strum = load("res://Scenes/Notes/Strum.tscn").instantiate()
		new_strum.dir = i
		new_strum.position = Vector2(125, 600)
		new_strum.scale = Vector2(0.7 * (4.0 / Game.key_count), 0.7 * (4.0 / Game.key_count))
		if i >= Game.key_count:
			#if Setting.s_get("gameplay", "botplay"):
				#new_strum.type = 2
			#else:
			new_strum.type = 1
			new_strum.position.x += 300.0 * (0.7 * 4.0 / Game.key_count)
		else:
			new_strum.type = 0
		new_strum.position.x += 115.0 * (4.0 / Game.key_count) * i
		View.strum_pos.append(new_strum.position)
		strum_group.add_child(new_strum)

func character_set():
	for i in range(2):
		var character = load("res://Scenes/BF.tscn").instantiate()
		character.type = i
		$Characters.add_child(character)

func note_set():
	var ind := 0
	for i in Game.dir:
		#print("spawned")
		var new_note = note_scn.instantiate()
		new_note.ind = ind
		new_note.dir = Game.dir[ind]
		new_note.ms = Game.ms[ind]
		new_note.sus = Game.sus[ind]
		new_note.name = str(ind)
		if Game.dir[ind] >= Game.key_count:
			new_note.player = 1
		note_group.add_child(new_note)
		ind += 1

func keybind(key):
	if key <= 18:
		Setting.sub_input = Setting.keybind_default_sub[str(key) + "k"]
		Game.note_anim = View.keys[str(key) + "k"]
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
		Game.bf_miss.append(0)

func countdown():
	Game.cur_state = Game.COUNTDOWN
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	Audio.a_play("Three")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	$Countdown/Sprite.texture = countdowns[0]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("Two")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	$Countdown/Sprite.texture = countdowns[1]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("One")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	$Countdown/Sprite.texture = countdowns[2]
	$Countdown/Sprite.modulate.a = 1
	Audio.a_play("Go")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	start()
	
func start():
	Audio.a_play("Inst")
	Audio.a_play("Voices")
	Game.cur_state = Game.PLAYING

func quit():
	Game.cur_state = Game.NOT_PLAYING
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
	Game.song_data.clear()
	Game.who_sing.clear()
	Game.who_sing_section.clear()
	Game.bf_miss.clear()
	View.strum_pos.clear()
	Audio.a_title()
	await Trans.t_trans("Freeplay")
	Game.total_hit = 0
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

func restart():
	Game.cur_state = Game.NOT_PLAYING
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
	Game.song_data.clear()
	Game.who_sing.clear()
	Game.who_sing_section.clear()
	View.strum_pos.clear()
	Trans.t_trans("Gameplay")
	await get_tree().create_timer(0.25).timeout
	Game.total_hit = 0
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

extends Node2D

@onready var strum_group: CanvasLayer = get_node("Strums")
@onready var note_group: CanvasLayer = get_node("Notes")

var note_count: int
var cam_zoom: float = 1
var timer: SceneTreeTimer

var pause = preload("res://Scenes/Pause Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.a_stop("Freaky Menu")
	var song_data
	if Game.cur_diff == "normal":
		song_data = File.f_read("res://Assets/Data/Song Charts/" + Game.cur_song.to_lower() + "/" + Game.cur_song.to_lower() + ".json", ".json")
	else:
		song_data = File.f_read("res://Assets/Data/Song Charts/" + Game.cur_song.to_lower() + "/" + Game.cur_song.to_lower() + "-" + Game.cur_diff + ".json", ".json")
	Game.setup(song_data)
	
	cam_zoom = Game.defaultZoom
	
	if FileAccess.file_exists(Paths.p_song(Game.cur_song.to_lower() + "/Voices")):
		Audio.a_set("Voices", Paths.p_song(Game.cur_song.to_lower() + "/Voices"))
	else:
		Audio.a_set("Voices", "")
	Audio.a_set("Inst", Paths.p_song(Game.cur_song.to_lower() + "/Inst"))
	
	keybind(Game.key_count)
	strum_set()
	character_set()
	countdown()
	
	
func _process(_delta):
	if Game.cur_state != Game.SPAWN_END and Game.cur_state == Game.COUNTDOWN:
		if !timer:
			timer = get_tree().create_timer((60.0 / Audio.bpm) * 5)
		Audio.cur_ms = timer.time_left * -1000
	$Camera.zoom = Vector2(cam_zoom, cam_zoom)
	if Game.cur_state == Game.NOT_PLAYING: return
	if Game.cur_state != Game.SPAWN_END:
		for i in range(20000):
			if Game.cur_state == Game.SPAWN_END or !Game.ms[note_count] - Game.PRELOAD_SEC * 1000 <= Audio.cur_ms:
				break
			note_spawn()
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
func note_spawn():
	if Game.ms[note_count] - Game.PRELOAD_SEC * 1000 <= Audio.cur_ms:
		#print("spawned")
		var new_note = note_scn.instantiate()
		new_note.ind = note_count
		new_note.dir = Game.dir[note_count]
		new_note.ms = Game.ms[note_count]
		new_note.sus = Game.sus[note_count]
		if Game.dir[note_count] >= Game.key_count:
			new_note.player = 1
		note_group.add_child(new_note)
		if note_count == Game.ms.size() - 1:
			Game.cur_state = Game.SPAWN_END
		else:
			note_count += 1

func strum_set():
	for i in Game.key_count * 2:
		var new_strum = load("res://Scenes/Notes/Strum.tscn").instantiate()
		new_strum.dir = i
		new_strum.position = Vector2(120, 550)
		new_strum.scale = Vector2(0.7 * (4.0 / Game.key_count), 0.7 * (4.0 / Game.key_count))
		if i >= Game.key_count:
			if Setting.s_get("gameplay", "botplay"):
				new_strum.type = 2
			else:
				new_strum.type = 1
			new_strum.position.x += 150.0 * (0.7 * 4.0 / Game.key_count)
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

func keybind(key):
	if key <= 18:
		if key == 4:
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
		Game.dad_input.append(0)

func countdown():
	Game.cur_state = Game.COUNTDOWN
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	Audio.a_play("Three")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	Audio.a_play("Two")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
	Audio.a_play("One")
	await get_tree().create_timer(60.0 / Audio.bpm).timeout
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
	Game.dad_input.clear()
	Game.song_data.clear()
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
	Game.dad_input.clear()
	Game.song_data.clear()
	View.strum_pos.clear()
	await Trans.t_trans("Gameplay")
	Game.total_hit = 0
	Game.score = 0
	Game.health = 1.0
	Game.health_percent = 50.0
	Game.accuracy = 0.0
	Game.total_hit = 0.0
	Game.hit = 0
	Game.combo = 0
	Game.fc_state = "N/A"
	Game.rating_total = [0,0,0,0,0,0]

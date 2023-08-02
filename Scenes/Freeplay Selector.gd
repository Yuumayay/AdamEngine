extends Node2D

@onready var bg = get_parent().get_node("BG")
@onready var multi_label = get_parent().get_node("Info/Multi")
@onready var difficulty_label = get_parent().get_node("Info/Difficulty")
@onready var highscore_label = get_parent().get_node("Info/HighScore")

var select: int = 0
var child_count: int = 0
var selected: bool = false
var last_score := 0

var diff = ["easy", "normal", "hard"]
var diffselect = 1
var diff_count = 2

var json = File.f_read("user://ae_score_data.json", ".json")
var path: String

func _ready():
	var ind = 0
	for indexi in Paths.week_path_list:
		for index in DirAccess.get_files_at(indexi):
			var week_data = File.f_read(indexi + "/" + index, ".json")
			var songs = week_data.songs
			for i in songs:
				var new_song: RichTextLabel = get_parent().get_node("Template").duplicate()
				#var alphabet: Node = new_song.get_node("Alphabet")
				var songname = i[0]
				var icon = Paths.p_icon(i[1])
				if icon == load("res://Assets/Images/Icons/icon-face.png"):
					var label = new_song.get_node("Icon").get_node("Error")
					printerr("icon: icon not found")
					icon = load("res://Assets/Images/Icons/icon-face.png")
					label.visible = true
					label.text = "Icon \"" + i[1] + "\"\ndoes not exist"
				var songcolor: Color = Color(i[2][0] / 255.0, i[2][1] / 255.0, i[2][2] / 255.0, 1)
			
				new_song.text = songname.to_upper()
				new_song.ind = ind
				new_song.color = songcolor
				new_song.name = songname
				if icon.get_size() == Vector2(150, 150):
					new_song.get_node("Icon").hframes = 1
				if icon.get_size() == Vector2(300, 150):
					new_song.get_node("Icon").hframes = 2
				if icon.get_size() == Vector2(450, 150):
					new_song.get_node("Icon").hframes = 3
				new_song.get_node("Icon").texture = icon
				new_song.get_node("Icon").position.x += songname.length() * 54.5
			
				new_song.visible = true
				add_child(new_song)
				
				ind += 1
	child_count = get_child_count() - 1
	
	multi_label.text = str(Game.cur_multi)
	path = get_child(select).name.to_lower() + "-" + diff[diffselect]
	getSongScore()
	
	for i in get_child_count():
		if Paths.p_chart(get_child(i).name, "hard"):
			var songfile = File.f_read(Paths.p_chart(get_child(i).name, "hard"), ".json")
			Game.what_engine(songfile)
		else:
			print("failed")

func getSongScore():
	path = get_child(select).name.to_lower() + "-" + diff[diffselect]
	for i in json.song:
		if i.has(path):
			var s_score = lerp(last_score, int(i[path].score), 0.5)
			last_score = s_score
			var s_fc = i[path].fc_state
			var s_acc = str(i[path].accuracy)
			highscore_label.text = "personal best: " + str(ceil(s_score)) + " (" + s_acc + "%)\n" + s_fc
			return
	last_score = 0
	highscore_label.text = "personal best: unplayed"

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if select == 0:
				select = child_count
			else:
				select -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
		if Input.is_action_just_pressed("game_ui_left"):
			if Input.is_action_pressed("game_shift"):
				Game.cur_multi -= 0.05
				multi_label.text = str(Game.cur_multi)
			else:
				if diffselect == 0:
					diffselect = diff_count
				else:
					diffselect -= 1
		if Input.is_action_just_pressed("game_ui_right"):
			if Input.is_action_pressed("game_shift"):
				Game.cur_multi += 0.05
				multi_label.text = str(Game.cur_multi)
			else:
				if diffselect == diff_count:
					diffselect = 0
				else:
					diffselect += 1
		if Input.is_action_just_pressed("ui_accept"):
			accept()
		if Input.is_action_just_pressed("ui_cancel"):
			Game.can_input = false
			Audio.a_cancel()
			Trans.t_trans("Main Menu")
	update_position()
	getSongScore()

func update_position():
	difficulty_label.text = diff[diffselect]
	Game.cur_diff = diff[diffselect]
	if selected:
		get_child(select).position.x = lerp(get_child(select).position.x, 0 * -25.0 + 225.0, 0.25)
		get_child(select).position.y = lerp(get_child(select).position.y, -select * 150.0 + (275.0 + select * 150.0), 0.25)
		bg.modulate = get_child(select).color
		return
	for i in get_children():
		if i == get_child(select):
			bg.modulate = lerp(bg.modulate, i.color, 0.05)
		i.position.x = lerp(i.position.x, abs(select - i.ind) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (350.0 + i.ind * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

func accept():
	Game.cur_song = get_child(select).name
	if !Paths.p_chart(Game.cur_song, Game.cur_diff):
		return
	Game.can_input = false
	selected = true
	Audio.a_accept()
	for i in get_children():
		if i == get_child(select):
			i.accepted(true)
		else:
			i.accepted(false)

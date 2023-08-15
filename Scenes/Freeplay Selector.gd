extends Node2D

@onready var bg = get_parent().get_node("BG")
@onready var score_panel = get_parent().get_node("Info/ScorePanel")
@onready var diff_panel = get_parent().get_node("Info/DiffPanel")
@onready var multi_label = get_parent().get_node("Info/DiffPanel/Multi")
@onready var difficulty_label = get_parent().get_node("Info/DiffPanel/Difficulty")
@onready var difficulty_label2 = get_parent().get_node("Info/DiffPanel/Difficulty2")
@onready var highscore_label = get_parent().get_node("Info/ScorePanel/HighScore")
@onready var fc_state_label = get_parent().get_node("Info/ScorePanel/FCState")

var select: int = 0
var child_count: int = 0
var selected: bool = false
var last_score := 0

var diff := []
var diffselect = 0
var diff_count = 0

var json = File.f_read("user://ae_score_data.json", ".json")
var path: String

func _ready():
	var ind = 0
	
	diffselect = Game.diff
	Game.game_mode = Game.FREEPLAY
	Game.edit_jsonpath = ""
	
	for indexi in Paths.week_path_list:
		if !DirAccess.dir_exists_absolute(indexi): continue
		for index in DirAccess.get_files_at(indexi):
			var week_data = File.f_read(indexi + "/" + index, ".json")
			var songs = week_data.songs
			for i in songs:
				var new_song: RichTextLabel = get_parent().get_node("Template").duplicate()
				#var alphabet: Node = new_song.get_node("Alphabet")
				var songname = i[0]
				var icon = Paths.p_icon(i[1])
				if icon == Game.load_image("Assets/Images/Icons/icon-face.png"):
					var label = new_song.get_node("Icon").get_node("Error")
					printerr("icon: icon not found")
					icon = Game.load_image("Assets/Images/Icons/icon-face.png")
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
	
	if !Setting.eng():
		difficulty_label.hide()
		difficulty_label2.show()
	
	diff = Game.difficulty
	
	diff_count = Game.difficulty.size() - 1
	child_count = get_child_count() - 1
	
	multi_label.text = str(Game.cur_multi)
	path = get_child(select).name.to_lower() + "-" + diff[diffselect]
	getSongScore()
	
	#for i in get_child_count():
	#	if Paths.p_chart(get_child(i).name, "hard"):
	#		var songfile = File.f_read(Paths.p_chart(get_child(i).name, "hard"), ".json")
	#		Game.what_engine(songfile)
	#	else:
	#		print("failed")

func getSongScore():
	path = get_child(select).name.to_lower() + "-" + diff[diffselect]
	for i in json.song:
		if i.has(path):
			var s_score = lerp(last_score, int(i[path].score), 0.5)
			last_score = s_score
			var s_fc = i[path].fc_state
			var s_acc = str(i[path].accuracy)
			highscore_label.text = str(round(s_score)) + "\n(" + s_acc + "%)\n"
			fc_state_label.text = s_fc
			if s_fc == "Clear" or s_fc == "Failed":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(1, 1, 1), 0.1)
			elif s_fc == "SDCB":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(1, 0.75, 0.5), 0.1)
			elif s_fc == "FC":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(1, 1, 0.5), 0.1)
			elif s_fc == "GFC":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(1, 0.5, 1), 0.1)
			elif s_fc == "SFC":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(0.5, 1, 1), 0.1)
			elif s_fc == "MFC":
				score_panel.self_modulate = lerp(score_panel.self_modulate, Color(0.5, 0.5, 1), 0.1)
			return
	last_score = 0
	highscore_label.text = "unplayed"
	fc_state_label.text = "-"
	score_panel.self_modulate = lerp(score_panel.self_modulate, Color(1, 1, 1), 0.1)

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
			Audio.a_play("close2", 1.0, 5.0)
			if Input.is_action_pressed("game_shift"):
				Game.cur_multi -= 0.05
				multi_label.text = str(Game.cur_multi)
			else:
				difficulty_label.position.x = 458
				difficulty_label.modulate.a = 0
				difficulty_label2.position.x = 428
				difficulty_label2.modulate.a = 0
				if diffselect == 0:
					diffselect = diff_count
				else:
					diffselect -= 1
		if Input.is_action_just_pressed("game_ui_right"):
			Audio.a_play("open2", 1.0, 5.0)
			if Input.is_action_pressed("game_shift"):
				Game.cur_multi += 0.05
				multi_label.text = str(Game.cur_multi)
			else:
				difficulty_label.position.x = 258
				difficulty_label.modulate.a = 0
				difficulty_label2.position.x = 228
				difficulty_label2.modulate.a = 0
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
	if !Setting.eng():
		difficulty_label2.text = Setting.translate(diff[diffselect])
		difficulty_label2.position = lerp(difficulty_label2.position, Vector2(328, -2), 0.5)
		difficulty_label2.modulate.a = lerp(difficulty_label2.modulate.a, 1.0, 0.5)
	else:
		difficulty_label.text = diff[diffselect]
		difficulty_label.position = lerp(difficulty_label.position, Vector2(358, 30), 0.5)
		difficulty_label.modulate.a = lerp(difficulty_label.modulate.a, 1.0, 0.5)
	Game.cur_diff = diff[diffselect]
	if selected:
		get_child(select).position.x = lerp(get_child(select).position.x, 300.0, 0.25)
		get_child(select).position.y = lerp(get_child(select).position.y, -select * 150.0 + (300.0 + select * 150.0), 0.25)
		bg.modulate = get_child(select).color
		return
	for i in get_children():
		if i == get_child(select):
			bg.modulate = lerp(bg.modulate, i.color, 0.05)
		i.position.x = lerp(i.position.x, abs(select - i.ind) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (300.0 + i.ind * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

func accept():
	Game.cur_song = get_child(select).name
	if !Paths.p_chart(Game.cur_song, Game.cur_diff):
		return
	Game.can_input = false
	selected = true
	Audio.a_accept()
	get_parent().get_node("Alphabet").hide()
	var t = create_tween()
	t.set_trans(Tween.TRANS_ELASTIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(score_panel, "position", Vector2(1522, 12), 1)
	
	var t2 = create_tween()
	t2.set_trans(Tween.TRANS_ELASTIC)
	t2.set_ease(Tween.EASE_IN_OUT)
	t2.tween_property(diff_panel, "position", Vector2(1618, 92), 1)
	for i in get_children():
		if i == get_child(select):
			i.accepted(true)
		else:
			i.accepted(false)

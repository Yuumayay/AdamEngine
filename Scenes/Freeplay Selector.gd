extends Node2D

@onready var bg = get_parent().get_node("BG")

var select: int = 0
var child_count: int = 0
var selected: bool = false

var diff = ["easy", "normal", "hard", "god"]
var diffselect = 1
var diff_count = 3

func _ready():
	var ind = 0
	for index in DirAccess.get_files_at("res://Assets/Weeks"):
		var week_data = File.f_read("res://Assets/Weeks/" + index, ".json")
		var songs = week_data.songs
		for i in songs:
			var new_song: RichTextLabel = get_parent().get_node("Template").duplicate()
			var songname = i[0]
			var icon: Texture2D
			if FileAccess.file_exists("res://Assets/Images/Icons/" + i[1] + ".png"):
				icon = load("res://Assets/Images/Icons/" + i[1] + ".png")
			elif FileAccess.file_exists("res://Assets/Images/Icons/icon-" + i[1] + ".png"):
				icon = load("res://Assets/Images/Icons/icon-" + i[1] + ".png")
			elif FileAccess.file_exists("res://Assets/Images/Icons/" + i[1] + "-icons.png"):
				icon = load("res://Assets/Images/Icons/" + i[1] + "-icons.png")
			else:
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
	
	for i in get_child_count():
		if Paths.p_chart(get_child(i).name, "hard"):
			var songfile = File.f_read(Paths.p_chart(get_child(i).name, "hard"), ".json")
			Game.what_engine(songfile)
		else:
			print("failed")

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
			if diffselect == 0:
				diffselect = diff_count
			else:
				diffselect -= 1
		if Input.is_action_just_pressed("game_ui_right"):
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

func update_position():
	get_parent().get_node("Difficulty").text = diff[diffselect]
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
	selected = true
	Audio.a_accept()
	for i in get_children():
		if i == get_child(select):
			i.accepted(true)
		else:
			i.accepted(false)

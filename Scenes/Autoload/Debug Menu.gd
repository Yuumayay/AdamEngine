extends Node2D

@onready var bg = get_parent().get_node("BG")

var select: int = 0
var child_count: int = 0
var selected: bool = false

func _ready():
	var ind = 0
	var week_data = File.f_read(Paths.p_offset("Debug Menu/Offset.json"), ".json")
	var selectable = week_data.SelectableList
	for i in selectable:
		var new_song: RichTextLabel = get_parent().get_node("Template").duplicate()
		var songname = i
		var icon: Texture2D
		if FileAccess.file_exists("res://Assets/Images/Other Icons/" + songname + ".png"):
			icon = load("res://Assets/Images/Other Icons/" + songname + ".png")
		else:
			printerr("icon: icon not found")
			icon = load("res://Assets/Images/Icons/icon-face.png")
		
		new_song.text = songname.to_upper()
		new_song.ind = ind
		new_song.name = songname
		if icon.get_size() == Vector2(150, 150):
			new_song.get_node("Icon").hframes = 1
		if icon.get_size() == Vector2(300, 150):
			new_song.get_node("Icon").hframes = 2
		if icon.get_size() == Vector2(450, 150):
			new_song.get_node("Icon").hframes = 3
		new_song.get_node("Icon").texture = icon
		new_song.get_node("Icon").position.x += songname.length() * 54.5
		
		new_song.visible = false
		add_child(new_song)
		ind += 1
	child_count = get_child_count() - 1

func _process(_delta):
	if not Game.debug_mode:
		if bg.visible:
			bg.visible = false
			for i in get_children():
				i.visible = false
		return
	if Game.can_input:
		if Input.is_action_just_pressed("ui_up"):
			Audio.a_scroll()
			if select == 0:
				select = child_count
			else:
				select -= 1
		if Input.is_action_just_pressed("ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
		if Input.is_action_just_pressed("ui_accept"):
			Game.can_input = false
			selected = true
			Audio.a_accept()
			for i in get_children():
				if i == get_child(select):
					i.accepted(true)
				else:
					i.accepted(false)
	update_position()

func update_position():
	if selected:
		if Game.trans: get_child(select).visible = false
		get_child(select).position.x = lerp(get_child(select).position.x, 0 * -25.0 + 225.0, 0.25)
		get_child(select).position.y = lerp(get_child(select).position.y, -select * 150.0 + (275.0 + select * 150.0), 0.25)
		#bg.modulate = get_child(select).color
		return
	for i in get_children():
		i.visible = true
		i.position.x = lerp(i.position.x, abs(select - i.ind) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (275.0 + i.ind * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

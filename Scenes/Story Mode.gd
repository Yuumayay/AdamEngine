extends Node2D

@onready var list = $Weeks
@onready var tracks_label: Label = $SongList

var select: int = 0
var child_count: int = 0

var tracks: Dictionary = {}

func _ready():
	var ind := 0
	for i in DirAccess.get_files_at("res://Assets/Weeks"):
		var week = File.f_read("res://Assets/Weeks/" + i, ".json")
		var new_item: Node2D = $Template.duplicate()
		var weekName = week.weekName
		var fileName = i.get_basename()
		
		tracks[fileName] = []
		for song in week.songs:
			tracks[fileName].append(song[0])
		
		new_item.name = fileName
		new_item.ind = ind
		
		var sprite: Sprite2D = new_item.get_node("Sprite")
		
		sprite.texture = load(Paths.p_week_image(fileName))
		if Paths.p_week_image(fileName).contains("Missing"):
			new_item.get_node("Error").visible = true
			new_item.get_node("Error").text += "Missing week image\n\"" + fileName + ".png\""
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count = list.get_child_count() - 1
	update_tracks()

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if select == 0:
				select = child_count
			else:
				select -= 1
			update_tracks()
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
			update_tracks()
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Trans.t_trans("Main Menu")
	update_position()

func update_position():
	for i in list.get_children():
		i.position.x = 640
		i.position.y = lerp(i.position.y, -select * 125.0 + (525.0 + i.ind * 125.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

func update_tracks():
	var i = list.get_child(select)
	var index := 0
	tracks_label.text = ""
	tracks_label.add_theme_font_size_override("font_size", 30)
	for ind in tracks[i.name]:
		tracks_label.text += tracks[i.name][index] + "\n"
		index += 1
		if index >= 5:
			tracks_label.add_theme_font_size_override("font_size", 150 / index)

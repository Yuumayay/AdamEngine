extends Node2D

@onready var list = $Weeks
@onready var tracks_label: Label = $SongList

var arrow = "res://Assets/Images/Story Mode/ui_arrow.xml"

var difficulty: Array = [preload("res://Assets/Images/Story Mode/Difficulties/easy.png"),
preload("res://Assets/Images/Story Mode/Difficulties/normal.png"),
preload("res://Assets/Images/Story Mode/Difficulties/hard.png"),]

var select: int = 0
var child_count: int = 0
var diffselect = 1
var diff_count = 2
var selected: bool = false

var tracks: Dictionary = {}

func _ready():
	var ind := 0
	for i in DirAccess.get_files_at("res://Assets/Weeks"):
		var week = File.f_read("res://Assets/Weeks/" + i, ".json")
		var new_item: Node2D = $Template.duplicate()
		var weekName = week.weekName
		var storyName = week.storyName
		var fileName = i.get_basename()
		
		tracks[fileName] = []
		for song in week.songs:
			tracks[fileName].append(song[0])
		
		new_item.name = fileName
		new_item.ind = ind
		new_item.storyName = storyName
		
		var sprite: Sprite2D = new_item.get_node("Sprite")
		
		sprite.texture = load(Paths.p_week_image(fileName))
		if Paths.p_week_image(fileName).contains("Missing"):
			new_item.get_node("Error").visible = true
			new_item.get_node("Error").text += "Missing week image\n\"" + fileName + ".png\""
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	for i in range(2):
		var new_arrow: AnimatedSprite2D = Game.load_XMLSprite(arrow)
		if i == 0:
			new_arrow.position = Vector2(900, 512)
			new_arrow.name = "arrow1"
		if i == 1:
			new_arrow.position = Vector2(1220, 512)
			new_arrow.flip_h = true
			new_arrow.name = "arrow2"
		add_child(new_arrow)
	
	child_count = list.get_child_count() - 1
	update_tracks()
	update_difficulty()

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
		if Input.is_action_just_pressed("game_ui_left"):
			$arrow1.play("arrow push")
			if diffselect == 0:
				diffselect = diff_count
			else:
				diffselect -= 1
			update_difficulty()
		if Input.is_action_just_pressed("game_ui_right"):
			$arrow2.play("arrow push")
			if diffselect == diff_count:
				diffselect = 0
			else:
				diffselect += 1
			update_difficulty()
		if Input.is_action_just_released("game_ui_left"):
			$arrow1.play("arrow")
		if Input.is_action_just_released("game_ui_right"):
			$arrow2.play("arrow")
		if Input.is_action_just_pressed("ui_accept"):
			accept()
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Trans.t_trans("Main Menu")
	update_position()

func update_position():
	$Difficulty.position.y = lerp($Difficulty.position.y, 512.0, 0.25)
	$Difficulty.modulate.a = lerp($Difficulty.modulate.a, 1.0, 0.25)
	for i in list.get_children():
		i.position.x = 640
		i.position.y = lerp(i.position.y, -select * 125.0 + (525.0 + i.ind * 125.0), 0.25)
		if !selected: i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

func update_tracks():
	var i = list.get_child(select)
	var index := 0
	tracks_label.text = ""
	tracks_label.add_theme_font_size_override("font_size", 30)
	for ind in tracks[i.name]:
		tracks_label.text += tracks[i.name][index] + "\n"
		index += 1
		if index >= 5:
			tracks_label.add_theme_font_size_override("font_size", 150.0 / index)
	
	$WeekName.text = i.storyName

func update_difficulty():
	$Difficulty.scale = Vector2(1, 1)
	$Difficulty.position.y = 462
	$Difficulty.modulate.a = 0
	$Difficulty.texture = difficulty[diffselect]
	if $Difficulty.texture.get_width() >= 200:
		$Difficulty.scale = Vector2(200.0 / $Difficulty.texture.get_width(), 200.0 / $Difficulty.texture.get_width())

func accept():
	Audio.a_accept()
	selected = true
	Game.can_input = false
	Game.songList = tracks[list.get_child(select).name]
	Game.cur_song_index = 0
	Game.cur_song = Game.songList[Game.cur_song_index]
	Game.cur_diff = Game.difficulty[diffselect]
	Game.cur_week = list.get_child(select).name
	Game.is_story = true
	for i in list.get_children():
		if i == list.get_child(select):
			i.accepted(true)
		else:
			i.accepted(false)

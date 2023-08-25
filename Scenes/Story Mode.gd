extends Node2D

@onready var list = $Weeks
@onready var tracks_label: Label = $SongList
@onready var diffSprite: Sprite2D = $Difficulty
@onready var diffLabel: Label = $DifficultyLabel
@onready var weekNameLabel: Label = $WeekName
@onready var weekNameJPLabel: Label = $WeekNameJP
@onready var weekScoreLabel: Label = $WeekScore

var arrow = "Assets/Images/Story Mode/ui_arrow.xml"

var difficulty: Array = []
var difficulties := {}

var select: int = 0
var child_count: int = 0
var diffselect = 0
var diff_count = 0
var selected: bool = false

var tracks: Dictionary = {}

var weekScore := 0.0
var json = File.f_read("user://ae_week_score_data.json", ".json")

func _ready():
	var ind := 0
	
	Game.game_mode = Game.STORY
	Game.edit_jsonpath = ""
	
	for index in Paths.week_path_list:
		#if !DirAccess.get_files_at(index): continue
		if !DirAccess.dir_exists_absolute(index): continue
		for i in DirAccess.get_files_at(index):
			if i.get_extension() != "json":
				continue
			var week = File.f_read(index + "/" + i, ".json")
			difficulties[week.weekName] = week.difficulties.replace(" ", "").split(",")
			if week.hideStoryMode:
				continue
			var new_item: Node2D = $Template.duplicate()
			var weekName = week.weekName
			var storyName = Setting.get_translate(week, "storyName")
			var fileName = i.get_basename()
			
			tracks[fileName] = []
			for song in week.songs:
				tracks[fileName].append(song[0])
			
			new_item.name = fileName
			new_item.ind = ind
			new_item.storyName = storyName
			new_item.weekName = weekName
			
			var sprite: Sprite2D = new_item.get_node("Sprite")
			var week_image_path = Paths.p_week_image(fileName)
			
			sprite.texture = Game.load_image(week_image_path)
			if week_image_path.contains("Missing"):
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
	diffCheck()
	update_tracks()
	update_difficulty()

func diffCheck():
	Game.difficulty = difficulties[list.get_child(select).weekName]
	difficulty = []
	
	for i in Game.difficulty.size():
		difficulty.append(Game.load_image(Paths.p_diff(Game.difficulty[i])))
	
	if diff_count != Game.difficulty.size() - 1:
		diff_count = Game.difficulty.size() - 1
		if Game.difficulty.size() == 1:
			diffselect = 0
		else:
			diffselect = floor(Game.difficulty.size() / 2.0)
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
			diffCheck()
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
			update_tracks()
			diffCheck()
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
			Game.game_mode = Game.STORY
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Trans.t_trans("Main Menu")
			Game.game_mode = Game.TITLE
	update_position()

var lastScore := 0.0

func update_position():
	if !Setting.eng():
		diffLabel.position.y = lerp(diffLabel.position.y, 448.0, 0.25)
		diffLabel.modulate.a = lerp(diffLabel.modulate.a, 1.0, 0.25)
	diffSprite.position.y = lerp(diffSprite.position.y, 512.0, 0.25)
	diffSprite.modulate.a = lerp(diffSprite.modulate.a, 1.0, 0.25)
	lastScore = lerp(lastScore, weekScore, 0.5)
	weekScoreLabel.text = "week score: " + str(round(lastScore))
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
	
	if Setting.jpn():
		if weekNameLabel.visible:
			weekNameLabel.hide()
			weekNameJPLabel.show()
		weekNameJPLabel.text = i.storyName
	else:
		weekNameLabel.text = i.storyName
	
	var path = i.name.to_lower() + "-" + Game.difficulty[diffselect]
	
	if json:
		for ind in json.week:
			if ind.has(path):
				weekScore = ind[path].score
				return
	weekScore = 0

func update_difficulty():
	if !Setting.eng():
		if diffSprite.visible:
			diffSprite.hide()
			diffLabel.show()
		diffLabel.text = Setting.translate(Game.difficulty[diffselect])
		diffLabel.scale = Vector2(1, 1)
		diffLabel.position.y = 348
		diffLabel.modulate.a = 0
		if Game.difficulty_color.has(Game.difficulty[diffselect].to_lower()):
			diffLabel.add_theme_color_override("font_outline_color", Color(Game.difficulty_color[Game.difficulty[diffselect].to_lower()]))
		else:
			diffLabel.add_theme_color_override("font_outline_color", Color(1, 1, 1))
	diffSprite.scale = Vector2(1, 1)
	diffSprite.position.y = 462
	diffSprite.modulate.a = 0
	
	diffSprite.texture = difficulty[diffselect]
	if diffSprite.texture.get_width() >= 200:
		diffSprite.scale = Vector2(200.0 / diffSprite.texture.get_width(), 200.0 / diffSprite.texture.get_width())

func accept():
	Audio.a_accept()
	selected = true
	Game.can_input = false
	Game.songList = tracks[list.get_child(select).name]
	Game.cur_song_index = 0
	Game.cur_song = Game.songList[Game.cur_song_index]
	Game.cur_diff = Game.difficulty[diffselect]
	Game.cur_week = list.get_child(select).name
	for i in list.get_children():
		if i == list.get_child(select):
			i.accepted(true)
		else:
			i.accepted(false)

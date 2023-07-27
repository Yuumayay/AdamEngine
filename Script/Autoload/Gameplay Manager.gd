extends Node

const PRELOAD_SEC = 2

var can_input: bool = true
var trans: bool = false
var debug_mode: bool = false
var key_count: int = 4
var cur_multi: float = 1.0
var cur_speed: float = 1.0

enum {NOT_PLAYING, COUNTDOWN, PLAYING, SPAWN_END, PAUSE}
var cur_state: int = 0

var song_name: Array
var notes: Array
var note_property: Array
var notes_data: Dictionary = {"notes": []}
var dir: Array
var ms: Array

var sus: Array
var type: Array

var who_sing: Array
var who_sing_section: Array
var mustHit: bool
var cur_input: Array
var cur_input_str: String
var dad_input: Array

enum {PERF, SICK, GOOD, BAD, SHIT, MISS}
var rating_offset: Array = [0.0, 20.0, 45.0, 75.0, 90.0, 135.0]

var note_anim: Array # = ["left", "down", "up", "right"]

# TODO Move to Setting
var language: String = "English"

var song_data: Dictionary

var rating_total: Array = [0, 0, 0, 0, 0, 0]
var rating_value: Array = [1, 1, 0.75, 0.5, 0.25, 0]
var health_gain: Array = [0.1, 0.08, 0.05, 0, -0.05]
var score_gain: Array = [400, 350, 200, 100, 0, -10]

var score: int
var health: float = 1.0
var health_percent: float = 50.0
var accuracy: float
var total_hit: float
var hit: int
var combo: int
var fc_state: String = "N/A"

var p1_position: Vector2
var p2_position: Vector2

## STAGE JSON ##
var stage: Dictionary
var defaultZoom: float

## SONG JSON ##
var cur_song: String = "test"
var cur_diff: String = "normal"
var cur_stage: String = "stage"
var player1: String = "bf"
var player2: String = "dad"

## CHARACTER JSON ##
var p1_json: Dictionary
var p2_json: Dictionary

func add_score(value):
	score += value

func set_score(value):
	score = value

func add_health(value):
	health += value
	health_percent = health * 50
	health = clamp(health, 0, 2)

func set_health(value):
	health = value
	health_percent = health * 50

func add_rating(value):
	rating_total[value] += 1
	if value == MISS:
		combo = 0
	else:
		combo += 1
	total_hit += rating_value[value]
		
	hit += 1
	accuracy = total_hit / hit

# json load
func setup(data):
	data = JSON.stringify(data)
	data = JSON.parse_string(data)
	
	song_data = data
	var song: Dictionary = data.song
	song_name.append(song.song)
	notes.append(song.notes)
	Audio.bpm = song.bpm
	key_count = 4
	
	stage = File.f_read("res://Assets/Data/Stages/" + cur_stage + ".json", ".json")
	defaultZoom = stage.defaultZoom
	
	player1 = song.player1
	player2 = song.player2
	
	if FileAccess.file_exists(Paths.p_chara(player1)):
		p1_json = File.f_read(Paths.p_chara(player1), ".json")
	else:
		p1_json = File.f_read(Paths.p_chara("bf"), ".json")
	if FileAccess.file_exists(Paths.p_chara(player2)):
		p2_json = File.f_read(Paths.p_chara(player2), ".json")
	else:
		p2_json = File.f_read(Paths.p_chara("dad"), ".json")
	
	if song.has("mania"):
		if song.mania == 0:
			key_count = 4
		if song.mania == 1:
			key_count = 6
		if song.mania == 2:
			key_count = 9
	if song.has("keyCount"):
		key_count = song.keyCount
	#key_count = 100
	for i in notes[0]:
		who_sing_section.append(i.mustHitSection)
		for ind in i.sectionNotes:
			if note_property.has(ind):
				continue
			who_sing.append(i.mustHitSection)
			ms.append(ind[0])
			note_property.append(ind)
			if i.mustHitSection:
				if ind[1] >= key_count:
					#dir.append(randi_range(0, key_count * 2 -1))
					dir.append(ind[1] - key_count)
				else:
					#dir.append(randi_range(0, key_count * 2 -1))
					dir.append(ind[1] + key_count)
			else:
				#dir.append(randi_range(0, key_count * 2 -1))
				dir.append(ind[1])
			
			sus.append(ind[2])

func what_engine(data):
	data = JSON.stringify(data)
	data = JSON.parse_string(data)
	
	if data.song.has("splashSkin"):
		print("its psych")
	elif data.song.has("songId"):
		print("its agoti")
	elif data.song.has("tableID"):
		print("its camellia")
	elif data.song.notes[0].has("startTime") or data.song.has("eventJson"):
		print("its forever")
	elif data.song.notes.has("keyNumber"):
		print("its yoshi")
	elif data.song.has("noteStyle"):
		print("its kade 1.4+")
	elif data.song.has("ui_Skin"):
		print("its leather")
	elif data.song.has("gfVersion") and data.song.has("player3") or data.song.has("hardness"):
		print("its denpa")
	elif data.song.has("screwYou"):
		print("its strident")
	elif data.song.has("validScore"):
		print("its old kade")
	else:
		print("its vannila")

# XML load
func load_XMLSprite(path, play_animation_name = "", loop_f = true, fps = 24, character = 0):
	var sprite_data:AnimatedSprite2D = AnimatedSprite2D.new() 
	
	var base_path:StringName = path.get_basename()
	#var file_name:StringName = path.get_file()
	
	var texture:Texture = load(base_path + ".png")
	
	var xml:XMLParser = XMLParser.new()
	xml.open(base_path + ".xml")
	
	var json: Dictionary
	if character == 1:
		json = p1_json
	elif character == 2:
		json = p2_json
	
	var frames:SpriteFrames = SpriteFrames.new() # アニメーションを管理 add_animationで追加
	
	sprite_data.frames = frames
	
	var anim_n := 0
	
	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_TEXT:
			var node_name:StringName = xml.get_node_name()
			
			if node_name.to_lower() == "subtexture":
				var frame_data:AtlasTexture
				
				var animation_name = xml.get_named_attribute_value("name")
				animation_name = animation_name.left(len(animation_name) - 4) #アニメ名の後ろ4つは連番
				animation_name = animation_name.to_lower()
				
				var no_anim = true
				if json:
					anim_n = 0
					for i in json.animations:
						var orginal_fnf_name = i.name.to_lower().replace("!", "").replace("0", "")#謎仕様に対応
						if animation_name == orginal_fnf_name:
							animation_name = i.anim.to_lower()
							no_anim = false
							break
						anim_n += 1
				
				var frame_rect:Rect2 = Rect2(
					Vector2(
						xml.get_named_attribute_value("x").to_float(),
						xml.get_named_attribute_value("y").to_float()
					),
					Vector2(
						xml.get_named_attribute_value("width").to_float(),
						xml.get_named_attribute_value("height").to_float()
					)
				)
				
				frame_data = AtlasTexture.new()
				frame_data.atlas = texture
				frame_data.region = frame_rect
				
				if xml.has_attribute("frameX"): #offsetをマージン設定に変換
					var margin:Rect2
					
					var raw_frame_x:int
					var raw_frame_y:int

					raw_frame_x = xml.get_named_attribute_value("frameX").to_int()
					raw_frame_y = xml.get_named_attribute_value("frameY").to_int()
				
					var raw_frame_width:int = xml.get_named_attribute_value("frameWidth").to_int()
					var raw_frame_height:int = xml.get_named_attribute_value("frameHeight").to_int()
					
					var frame_size_data:Vector2 = Vector2(
						raw_frame_width,
						raw_frame_height
					)
					
					if frame_size_data == Vector2.ZERO:
						frame_size_data = frame_rect.size
					
					margin = Rect2(#Vector2(-raw_frame_x, -raw_frame_y) ,
						Vector2(
							-int(xml.get_named_attribute_value("frameX")),
							-int(xml.get_named_attribute_value("frameY"))
						),
						Vector2(
							int(xml.get_named_attribute_value("frameWidth")) - frame_rect.size.x,
							int(xml.get_named_attribute_value("frameHeight")) - frame_rect.size.y
						)
							#Vector2(raw_frame_width - frame_rect.size.x,
									#raw_frame_height - frame_rect.size.y)
					)					
					if margin.size.x < abs(margin.position.x):
						margin.size.x = abs(margin.position.x)
					if margin.size.y < abs(margin.position.y):
						margin.size.y = abs(margin.position.y)
					
					frame_data.margin = margin 
				
				frame_data.filter_clip = true
				
				if not frames.has_animation(animation_name):
					frames.add_animation(animation_name)
					frames.set_animation_loop(animation_name, loop_f)
					frames.set_animation_speed(animation_name, fps)
					anim_n += 1
				
				frames.add_frame(animation_name, frame_data)
				if play_animation_name == "":
					play_animation_name = animation_name
	
	#ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
	
	sprite_data.play(play_animation_name)
	
	return sprite_data
	

func _input(event):
	if cur_state == NOT_PLAYING or cur_state == PAUSE: return
	#print(event.as_text())
	var input = Setting.input.find(event.as_text())
	var sub_input = Setting.sub_input.find(event.as_text())
	if input != -1 and cur_input:
		if event.is_released():
			cur_input_str = ""
			cur_input[input] = 0
			#print("lol")
		else:
			if cur_input[input] == 0:
				cur_input_str = event.as_text()
				cur_input[input] = 2
				await get_tree().create_timer(0).timeout #processに変更
				if cur_state == NOT_PLAYING or cur_state == PAUSE: return
				cur_input[input] = 1
	if sub_input != -1 and cur_input:
		if event.is_released():
			cur_input_str = ""
			cur_input[sub_input] = 0
			#print("lol")
		else:
			if cur_input[sub_input] == 0:
				cur_input_str = event.as_text()
				cur_input[sub_input] = 2
				await get_tree().create_timer(0).timeout #processに変更
				if cur_state == NOT_PLAYING or cur_state == PAUSE: return
				cur_input[sub_input] = 1
			#print(cur_input)

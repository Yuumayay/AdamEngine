extends Node

signal game_ready
signal song_start

const PRELOAD_SEC = 2

var progress := 0
var gf_pet_total := 0.0

var can_input: bool = true
var trans: bool = false
var debug_mode: bool = false
var key_count : Array = [4,4,4]
enum {KC_BF, KC_DAD, KC_GF}
var cur_multi: float = 1.0
var cur_speed: float = 1.0

enum {ADAM, PSYCH, LEATHER, KADE, DENPA, STRIDENT}
var song_engine_type := 0

enum {SAME, NULL}

var psych_character_property := {"animations": "animations",
	"no_antialiasing": "no_antialiasing",
	"image": "image",
	"position": "position",
	"healthicon": "healthicon",
	"flip_x": "flip_x",
	"healthbar_colors": "healthbar_colors",
	"camera_position": "camera_position",
	"sing_dulation": "sing_dulation",
	"scale": "scale"}

var character_property := [
	{"animations": SAME,
	"no_antialiasing": SAME,
	"image": SAME,
	"position": SAME,
	"healthicon": SAME,
	"flip_x": SAME,
	"healthbar_colors": SAME,
	"camera_position": SAME,
	"sing_dulation": SAME,
	"scale": SAME},
	
	{"animations": SAME,
	"no_antialiasing": SAME,
	"image": SAME,
	"position": SAME,
	"healthicon": SAME,
	"flip_x": SAME,
	"healthbar_colors": SAME,
	"camera_position": SAME,
	"sing_dulation": SAME,
	"scale": SAME},
	
	{"animations": SAME,
	"no_antialiasing": NULL,
	"image": "imagePath",
	"position": "positionOffset",
	"healthicon": "healthIcon",
	"flip_x": "defaultFlipX",
	"healthbar_colors": "barColor",
	"camera_position": "cameraOffset",
	"sing_dulation": NULL,
	"scale": "graphicSize"},
]

enum {NOT_PLAYING, COUNTDOWN, PLAYING, PAUSE, GAMEOVER}
var cur_state: int = 0

var spawn_end: bool = false

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
var kps: Array
var dad_kps: Array
var nps: Array
var max_nps: float
var cur_input_sub: Array
var dad_input: Array
var gf_input: Array
var bf_miss: Array
var bf_hit_bool: bool

enum {PERF, SICK, GOOD, BAD, SHIT, MISS, LONG_NOTE}
var rating_offset: Array = [0.0, 20.0, 45.0, 75.0, 90.0, 135.0]

var note_anim: Array # = ["left", "down", "up", "right"]

# TODO Move to Setting
var language: String = "English"

var song_data: Dictionary

var difficulty: Array = ["easy", "normal", "hard"]
var difficulty_case := ["easy", "normal", "hard", "hardcore", "insane", "harder", "canon", "mania", "voiid", "god", "old", "hell", "adamized"]
var difficulty_color := {"easy": Color(0, 1, 0), "normal": Color(1, 1, 0), "hard": Color(1, 0, 0),
"hardcore": Color("ff00ff"), "insane": Color(0.9, 0.9, 0.9), "harder": Color(1, 0, 0),
"canon": Color("74a5ff"), "mania": Color("74a539"), "voiid": Color("820094"), "god": Color("5cffff"),
"old": Color(0.6,0.6,0.6), "hell": Color(0.7, 0, 0), "adamized": Color(1, 1, 1)}

## GAMEPLAY CONSTS ##
const rating_value: Array = [1, 1, 0.75, 0.5, 0.25, 0]
#const health_gain: Array = [0.1, 0.08, 0.05, 0, -0.05]
const health_gain: Array = [0.1, 0.08, 0.05, -0.05, -0.1, -0.2, 0.005]
const score_gain: Array = [400, 350, 200, 100, 0, -10]
#const difficulty: Array = ["easy", "normal", "hard"]
const sus_tolerance: float = 200.0


## GAMEPLAY PROPERTY ##
var score: int
var health: float = 1.0
var health_percent: float = 50.0
var accuracy: float
var accuracy_percent: float
var total_hit: float
var hit: int
var combo: int
var max_combo: int
var fc_state: String = "N/A"

var rating_name := ["Marvelous", "Sick", "Good", "Bad", "Shit", "Misses"]
var fc_name := ["MFC", "SFC", "GFC", "FC", "SDCB", "Clear"]
var rating_total: Array = [0, 0, 0, 0, 0, 0]
var cur_rating: String

#var is_story: bool
enum {TITLE, FREEPLAY, STORY}
var game_mode: int = TITLE
var edit_jsonpath : String = "" #曲をエディットしている場合。
var saveScore := true
var songList: Array
var cur_song_index: int
var skipCountdown := false
var loadAudioByDifficulty := false
var timeText: String

## GAMEPLAY WEEK PROPERTY ##
var cur_week: String

var week_score: int
var week_accuracy: float
var week_total_hit: float
var week_hit: int
var week_fc_state: Array
var week_rating_total: Array = [0, 0, 0, 0, 0, 0]

## STAGE JSON ##
var stage: Dictionary
var defaultZoom: float
var isPixel: bool
var lockCam: bool

## SONG JSON ##
const DEFAULT_SONG = "bopeebo"
var cur_song: String = DEFAULT_SONG
var cur_song_path: String
var cur_song_data_path: String
var chara_image_path: Array
var noteXML: String
var specialNotes: Array
var chara_json: Array
var cur_diff: String = "normal" #現在の難易度（文字列
var cur_stage: String = "stage"
var stage_json: Dictionary
var player1: String = "bf"
var player2: String = "dad"
var player3 = "gf"
var note_type: Array

func get_diff_i():
	var n = 0
	for i in difficulty:
		if cur_diff.to_lower() == i.to_lower():
			return n
		n += 1
	return 0

var is3D: bool = false

## CHARACTER JSON ##
var p1_json: Dictionary
var p2_json: Dictionary
var gf_json: Dictionary

var iconBF: String:
	set(v):
		iconBF = v
		if v == "":
			return
		elif FileAccess.file_exists(v):
			return
		else:
			var healthBarBG = get_node_or_null("/root/Gameplay/UI/HealthBarBG")
			if healthBarBG:
				healthBarBG.iconUpdate()
var iconDAD: String:
	set(v):
		iconDAD = v
		if v == "":
			return
		elif FileAccess.file_exists(v):
			return
		else:
			var healthBarBG2 = get_node_or_null("/root/Gameplay/UI/HealthBarBG")
			if healthBarBG2:
				healthBarBG2.iconUpdate()

var bf_load_fail: bool
var dad_load_fail: bool
var gf_load_fail: bool

func add_score(value):
	score += value
	week_score += value

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
	cur_rating = rating_name[value]
	rating_total[value] += 1
	week_rating_total[value] += 1
	if value == MISS:
		combo = 0
	else:
		combo += 1
	if combo >= max_combo:
		max_combo = combo
	total_hit += rating_value[value]
	week_total_hit += rating_value[value]
		
	hit += 1
	week_hit += 1
	accuracy = total_hit / hit
	accuracy_percent = floor(accuracy * 10000.0) / 100.0
	week_accuracy = week_total_hit / week_hit
	
func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false

func get_json_keycount(song):
	var ret : Array = [4, 4, 4]
	if song.has("mania"):
		if song.mania == 0:
			ret = [4, 4, 4]
		elif song.mania == 1:
			ret = [6, 6, 6]
		elif song.mania == 2:
			ret = [9, 9, 9]
		elif song.mania == 3:
			ret = [9, 9, 9]
	if song.has("keyCount"):
		ret = [song.keyCount,song.keyCount,song.keyCount]
		if song.has("playerKeyCount"):
			ret[0] = song.playerKeyCount
		
	#Adam仕様keycount
	if song.has("player1KeyCount"): 
		ret[0] = song.player1KeyCount
	if song.has("player2KeyCount"): 
		ret[1] = song.player2KeyCount
	if song.has("player3KeyCount"): 
		ret[2] = song.player3KeyCount
	
	print("load keycount", ret)
	return ret

# songのプロパティチェックのテンプレート
func check_property_and_set(dict, key, init = null):
	if dict.has(key):
		# keyがdictの中で見つかった場合、dict[key]を返す（プロパティに合わせる）
		return dict[key]
	# keyがdictの中で見つからない場合、Game[key]を返す（変えない）
	if init != null:
		return init
	return Game[key]

# json load
func setup(data):
	data = JSON.stringify(data)
	data = JSON.parse_string(data)
	
	song_data = data
	var song: Dictionary = data.song
	song_name.append(song.song)
	notes.append(song.notes)
	cur_speed = song.speed / cur_multi
	Audio.bpm = song.bpm * cur_multi
	key_count = [4, 4, 4]
	loadAudioByDifficulty = check_property_and_set(song, "loadAudioByDifficulty")
	
	if stage_json:
		stage = stage_json
		defaultZoom = stage.defaultZoom
		isPixel = stage.isPixelStage
		lockCam = check_property_and_set(stage, "lockCam")
	else:
		if song.has("stage"):
			cur_stage = song.stage
		else:
			cur_stage = "stage"
		if Paths.p_stage_data(cur_stage):
			stage = File.f_read(Paths.p_stage_data(cur_stage), ".json")
			defaultZoom = stage.defaultZoom
			isPixel = stage.isPixelStage
			lockCam = check_property_and_set(stage, "lockCam")
		else:
			stage = File.f_read(Paths.p_stage_data("stage"), ".json")
			defaultZoom = 1.0
			isPixel = false
			lockCam = false
	
	player1 = song.player1
	player2 = song.player2
	if song.has("player3"):
		if song.player3:
			player3 = song.player3
		else:
			player3 = "gf"
	elif song.has("gfVersion"):
		player3 = song.gfVersion
	else:
		if player2 != "gf":
			player3 = "gf"
		else:
			player3 = "none"
	print("p1: ", player1, " p2: ", player2, " p3: ", player3)
	if chara_json:
		var jsonlist := [p1_json, p2_json, gf_json]
		var faillist := [bf_load_fail, dad_load_fail, gf_load_fail]
		var default := ["bf", "dad", "gf"]
		for j in range(3):
			if chara_json[j] != {}:
				jsonlist[j] = chara_json[j]
				faillist[j] = false
			else:
				jsonlist[j] = File.f_read(Paths.p_chara(default[j]), ".json")
				faillist[j] = true
		p1_json = jsonlist[0]
		p2_json = jsonlist[1]
		gf_json = jsonlist[2]
		bf_load_fail = faillist[0]
		dad_load_fail = faillist[1]
		gf_load_fail = faillist[2]
	else:
		if Paths.p_chara(player1):
			p1_json = File.f_read(Paths.p_chara(player1), ".json")
			bf_load_fail = false
		else:
			p1_json = File.f_read(Paths.p_chara("bf"), ".json")
			bf_load_fail = true
		if Paths.p_chara(player2):
			p2_json = File.f_read(Paths.p_chara(player2), ".json")
			dad_load_fail = false
		else:
			p2_json = File.f_read(Paths.p_chara("dad"), ".json")
			dad_load_fail = true
		if Paths.p_chara(player3):
			gf_json = File.f_read(Paths.p_chara(player3), ".json")
			gf_load_fail = false
		else:
			gf_json = File.f_read(Paths.p_chara("gf"), ".json")
			gf_load_fail = true
	
	if song.has("is3D"):
		is3D = song.is3D
	
	key_count = get_json_keycount(song)
		
	for i in notes[0]:
		var sectionNotes : Array= i.sectionNotes
		sectionNotes.sort_custom(sort_ascending) # notesがたまに整列してないため時間で並び替え
		who_sing_section.append(i.mustHitSection)
		for ind in i.sectionNotes:
			if note_property.has(ind):
				continue
			who_sing.append(i.mustHitSection)
			ms.append(ind[0])
			note_property.append(ind)
			if i.mustHitSection: # BF---------------
				if ind[1] >= key_count[KC_BF] + key_count[KC_DAD]: # GF
					dir.append(ind[1])
					
				elif ind[1] >= key_count[KC_BF]: #DAD
					dir.append(ind[1] - key_count[KC_BF])
					
				else: #BF
					dir.append(ind[1] + key_count[KC_DAD])
			else:# DAD-----------------
				dir.append(ind[1])
			
			sus.append(ind[2])
			if ind.size() == 4:
				pass
			elif ind.size() == 5:
				if ind[4] is String:
					note_type.append(ind[4])
	emit_signal("game_ready")

func what_engine(data):
	data = JSON.stringify(data)
	data = JSON.parse_string(data)
	
	if data.song.has("splashSkin") or data.song.has("uiType"):
		print("its psych")
	elif data.song.has("screwYou"):
		print("its strident")
	elif data.song.notes[0].has("startTime") or data.song.has("eventJson"):
		print("its forever")
	elif data.song.has("songId"):
		print("its agoti")
	elif data.song.has("tableID"):
		print("its camellia")
	elif data.song.has("offset"):
		print("its kade 1.8")
	elif data.song.has("noteStyle"):
		print("its kade 1.4+")
	elif data.song.notes.has("keyNumber"):
		print("its yoshi")
	elif data.song.has("ui_Skin"):
		print("its leather")
	elif data.song.has("autoIcons"):
		print("its denpa")
	elif data.song.has("validScore"):
		print("its old kade")
	else:
		print("its vannila")


var conv_anim_name_dict = {
	"bf idle dance": "idle",
	"gf dancing beat": "idle",
	"dad idle dance": "idle",
}
func conv_anim_name(text : String):
	# 特殊なアニメ名は辞書ベースで変換してあげる
	if conv_anim_name_dict.has(text):
		return conv_anim_name_dict[text]
	return text

# ファイルのイメージをオンラインで読む
func load_image(path):
	var texture:Texture
	var image = Image.new()
	image.load(path)
	texture = ImageTexture.create_from_image(image)
	return texture
	
# XML load
var sprite_cache = {}
var play_animation_name_cache = {}

func load_XMLSprite(path, play_animation_name = "", loop_f = true, fps = 24, character = 0):
	if sprite_cache.has(path):
		print("sprite xml on cache: ", path)
		#var sprite_data:AnimatedSprite2D = AnimatedSprite2D.new()
		#sprite_data.frames = sprite_cache[path].duplicate()
		#if sprite_data.sprite_frames.has_animation(play_animation_name):
		var sprite_data:AnimatedSprite2D = sprite_cache[path].duplicate()
		if play_animation_name == "":
		#	var anims : Array = sprite_data.sprite_frames.get_animation_names()
		#	var i = anims.find("default")
		#	if i > 0:
		#		anims.remove_at(i)
		#	play_animation_name = anims[-1]
			play_animation_name = play_animation_name_cache[path]
		
		sprite_data.play(play_animation_name)
		return sprite_data
		
	print("sprite xml load start: ", path)
	if !FileAccess.file_exists(path):
		Audio.a_play("Error")
		printerr("invalid path. cannot load xml")
		var sprite = AnimatedSprite2D.new()
		var frames:SpriteFrames = SpriteFrames.new()
		frames.add_frame("default", Game.load_image("Assets/Images/UI/Missing.png"))
		sprite.frames = frames
		return sprite
	
	var sprite_data:AnimatedSprite2D = AnimatedSprite2D.new() 
	
	var base_path:StringName = path.get_basename()
	
	#var texture:Texture = load( base_path + ".png")
	var texture:Texture = load_image(base_path + ".png")
	
	var xml:XMLParser = XMLParser.new()
	xml.open(base_path + ".xml")
	
	var json: Dictionary
	if character == 1:
		json = p1_json
	elif character == 2:
		json = p2_json
	
	var frames:SpriteFrames = SpriteFrames.new() # アニメーションを管理 add_animationで追加
	
	sprite_data.sprite_frames = frames
	
	var idle_f = false
	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_TEXT:
			var node_name:StringName = xml.get_node_name()
			
			if node_name.to_lower() == "subtexture":
				var anim_loop = loop_f
				var frame_data:AtlasTexture
				
				var animation_name = xml.get_named_attribute_value("name")
				animation_name = animation_name.left(len(animation_name) - 4) #アニメ名の後ろ4つは連番
				animation_name = animation_name.to_lower()
				
				var convname = conv_anim_name(animation_name) #特殊なBF、GFなどのアニメ名は辞書で正規化
				var json_anim = false
				
				if convname != animation_name:
					animation_name = convname
					
				else: # 辞書にないパターン
					var no_anim = true
					if json: # jsonがあったらjsonのアニメ名を使う
						for i in json.animations:
							var orginal_fnf_name = i.name.to_lower().replace("!", "").replace("0", "")#謎仕様に対応
							if orginal_fnf_name == animation_name:
								animation_name = i.anim.to_lower()
								#print(i.name, " -> ", orginal_fnf_name," -> ", animation_name)
								no_anim = false
								json_anim = true
								anim_loop = i.loop
								break
						
					if !json_anim and((!json) or no_anim): # jsonがないか、jsonに対応するアニメがない
						if animation_name.contains("idle"): # 特殊変換処理
							if animation_name.contains("shaking"):
								animation_name = "shaking"
							else:
								animation_name = "idle"
							
					if !json_anim and character != 0: #キャラクターだったら　アニメ名を正規化
						for anim in View.keys["4k"].duplicate():
							var i = anim.replace("2", "")
							if animation_name.contains(i):
								if animation_name.contains("dance"):
									animation_name = "dance" + i
								elif animation_name.contains("miss"):
									animation_name = "sing" + i + "miss"
								else:
									animation_name = "sing" + i
									
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
					
					var raw_frame_width:int = xml.get_named_attribute_value("frameWidth").to_int()
					var raw_frame_height:int = xml.get_named_attribute_value("frameHeight").to_int()
					
					var frame_size_data:Vector2 = Vector2(
						raw_frame_width,
						raw_frame_height
					)
					
					if frame_size_data == Vector2.ZERO:
						frame_size_data = frame_rect.size
					
					margin = Rect2(
						Vector2(
							-int(xml.get_named_attribute_value("frameX")),
							-int(xml.get_named_attribute_value("frameY"))
						),
						Vector2(
							int(xml.get_named_attribute_value("frameWidth")) - frame_rect.size.x,
							int(xml.get_named_attribute_value("frameHeight")) - frame_rect.size.y
						)
					)					
					if margin.size.x < abs(margin.position.x):
						margin.size.x = abs(margin.position.x)
					if margin.size.y < abs(margin.position.y):
						margin.size.y = abs(margin.position.y)
					
					frame_data.margin = margin 
				
				frame_data.filter_clip = true
				
				if not frames.has_animation(animation_name):
					frames.add_animation(animation_name)
					frames.set_animation_loop(animation_name, anim_loop)
					frames.set_animation_speed(animation_name, fps)
					print("new anim:", path, animation_name, anim_loop)
					if !json_anim and character != 0:
						print(xml.get_named_attribute_value("name"), " -> not found...", animation_name)
				
				frames.add_frame(animation_name, frame_data)
				if play_animation_name == "":
					play_animation_name = animation_name
	
	
	#ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
	sprite_cache[path] = sprite_data
	play_animation_name_cache[path] = play_animation_name
	
	var ret : AnimatedSprite2D = sprite_data.duplicate()
	if ret.sprite_frames.has_animation(play_animation_name):
		ret.play(play_animation_name)
		
	return ret


# XML load 3D
func load_XMLSprite3D(path, play_animation_name = "", loop_f = true, fps = 24, character = 0):
	var ret = load_XMLSprite(path, play_animation_name, loop_f, fps, character)
	var sprite_data:AnimatedSprite3D = AnimatedSprite3D.new() 
	sprite_data.sprite_frames = ret.sprite_frames
	sprite_data.play(play_animation_name)
	
	return sprite_data

const gf_key_case := ["gfVersion", "player3"]

func get_gf_name(json):
	for i in gf_key_case:
		if json.has(i):
			return json[i]
	return "none"

func getColor(t: Texture2D, r1: int, r2: int) -> Color:
	var colorArray: Array = []
	var colorArray2: Array = []
	var colorCount: Array = []
	var image = t.get_image()
	for i in range(r1, r2):
		for ind in range(r1, r2):
			var pixelColor: Color = image.get_pixel(i, ind)
			if pixelColor.a == 1 and pixelColor != Color(0, 0, 0, 1):
				if not colorArray.has(pixelColor):
					colorArray2.append(pixelColor)
				colorArray.append(pixelColor)
			else:
				continue
	if colorArray != []:
		var index := 0
		for i in colorArray2:
			colorCount.append([colorArray.count(i), index])
			index += 1
		colorCount.sort()
		return colorArray2[colorCount[0][1]]
	return Color(0, 0, 0, 1)

func get_preload_sec():
	# 先読み時間をゲームスピードを考慮して計算
	return (Game.PRELOAD_SEC / Game.cur_speed) / 0.75

func _input(event):
	if cur_state == NOT_PLAYING or cur_state == PAUSE: return
	#print(event.as_text())
	var input = Setting.input.find(event.as_text())
	var sub_input = Setting.sub_input.find(event.as_text().to_lower())
	if input != -1 and cur_input:
		if event.is_released():
			cur_input_str = ""
			cur_input[input] = 0
		else:
			if cur_input[input] == 0:
				cur_input_str = event.as_text()
				cur_input[input] = 2
				kps.append(1.0)
				await get_tree().create_timer(0).timeout #processに変更
				if cur_state == NOT_PLAYING or cur_state == PAUSE: return
				cur_input[input] = 1
				ghostTappingCheck(input)
				
	if sub_input != -1 and cur_input_sub: #サブインプット（方向キー。）
		if event.is_released():
			cur_input_sub[sub_input] = 0 
			cur_input[sub_input] = cur_input_sub[sub_input]#cur_inputを上書きする。
		else:
			if cur_input_sub[sub_input] == 0:
				cur_input_sub[sub_input] = 2
				kps.append(1.0)
				cur_input[sub_input] = cur_input_sub[sub_input]#cur_inputを上書きする。
				await get_tree().create_timer(0).timeout #processに変更
				if cur_state == NOT_PLAYING or cur_state == PAUSE: return
				cur_input_sub[sub_input] = 1
				cur_input[sub_input] = cur_input_sub[sub_input]#cur_inputを上書きする。
				ghostTappingCheck(sub_input)

func ghostTappingCheck(input):
	if Modchart.mGet("ghostTapping"):
		if bf_hit_bool:
			Game.bf_hit_bool = false
			return
		if Modchart.mGet("ghostTapping", 1):
			Game.add_rating(Game.MISS)
		if Modchart.mGet("ghostTapping", 2):
			Game.bf_miss[input] = 1
		Game.add_health(Modchart.mGet("ghostTapping", 0) * -1)

func _process(_delta):
	if Input.is_action_just_pressed("game_fullscreen"):
		if get_window().mode == Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_FULLSCREEN

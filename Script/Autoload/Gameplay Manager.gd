extends Node

signal game_ready

const PRELOAD_SEC = 2

var can_input: bool = true
var trans: bool = false
var debug_mode: bool = false
var key_count : Array = [4,4,4]
enum {KC_BF, KC_DAD, KC_GF}
var cur_multi: float = 1.0
var cur_speed: float = 1.0

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
var cur_input_sub: Array
var dad_input: Array
var gf_input: Array
var bf_miss: Array
var bf_hit_bool: bool

enum {PERF, SICK, GOOD, BAD, SHIT, MISS}
var rating_offset: Array = [0.0, 20.0, 45.0, 75.0, 90.0, 135.0]

var note_anim: Array # = ["left", "down", "up", "right"]

# TODO Move to Setting
var language: String = "English"

var song_data: Dictionary

var difficulty: Array = ["easy", "normal", "hard"]
var difficulty_color: Array = [Color(0, 1, 0), Color(1, 1, 0), Color(1, 0, 0)]
var diff := 1 #現在の難易度

## GAMEPLAY CONSTS ##
const rating_value: Array = [1, 1, 0.75, 0.5, 0.25, 0]
#const health_gain: Array = [0.1, 0.08, 0.05, 0, -0.05]
const health_gain: Array = [0.1, 0.08, 0.05, -0.05, -0.1]
const score_gain: Array = [400, 350, 200, 100, 0, -10]
#const difficulty: Array = ["easy", "normal", "hard"]
const sus_tolerance: float = 200.0

## GAMEPLAY PROPERTY ##
var score: int
var health: float = 1.0
var health_percent: float = 50.0
var accuracy: float
var total_hit: float
var hit: int
var combo: int
var max_combo: int
var fc_state: String = "N/A"

var rating_total: Array = [0, 0, 0, 0, 0, 0]

#var is_story: bool
enum {TITLE, FREEPLAY, STORY}
var game_mode: int = TITLE
var edit_jsonpath : String = "" #曲をエディットしている場合。
var saveScore: bool
var songList: Array
var cur_song_index: int
var skipCountdown := false

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

## SONG JSON ##
const DEFAULT_SONG = "bopeebo"
var cur_song: String = DEFAULT_SONG
var cur_song_path: String
var cur_song_data_path: String
var cur_diff: String = "normal": #現在の難易度（文字列
	set(v): # クソコード
		cur_diff = v
		var n = 0
		for i in difficulty:
			if v == i:
				diff = n
			n += 1
	get:
		return difficulty[diff]
		
var cur_stage: String = "stage"
var player1: String = "bf"
var player2: String = "dad"
var player3 = "gf"

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
		var healthBarBG = get_node_or_null("/root/Gameplay/UI/HealthBarBG")
		if healthBarBG:
			healthBarBG.iconUpdate()
var iconDAD: String:
	set(v):
		iconDAD = v
		if v == "":
			return
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
		if song.mania == 1:
			ret = [6, 6, 6]
		if song.mania == 2:
			ret = [9, 9, 9]
			
	if song.has("keyCount"):
		ret = [song.keyCount,song.keyCount,song.keyCount]
		
	#Adam仕様keycount
	if song.has("player1KeyCount"): 
		ret[0] = song.player1KeyCount
	if song.has("player2KeyCount"): 
		ret[1] = song.player2KeyCount
	if song.has("player3KeyCount"): 
		ret[2] = song.player3KeyCount
	
	print("load keycount", ret)
	return ret

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
	
	if song.has("stage"):
		cur_stage = song.stage
	else:
		cur_stage = "stage"
	if Paths.p_stage_data(cur_stage):
		stage = File.f_read(Paths.p_stage_data(cur_stage), ".json")
		defaultZoom = stage.defaultZoom
		isPixel = stage.isPixelStage
	else:
		stage = File.f_read(Paths.p_stage_data("stage"), ".json")
		defaultZoom = 1.0
		isPixel = false
	
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
					dir.append(ind[1] + key_count[KC_BF])
			else:# DAD-----------------
				dir.append(ind[1])
			
			sus.append(ind[2])
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
func load_XMLSprite(path, play_animation_name = "", loop_f = true, fps = 24, character = 0):
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
	
	sprite_data.frames = frames
	
	var idle_f = false
	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_TEXT:
			var node_name:StringName = xml.get_node_name()
			
			if node_name.to_lower() == "subtexture":
				var frame_data:AtlasTexture
				
				var animation_name = xml.get_named_attribute_value("name")
				animation_name = animation_name.left(len(animation_name) - 4) #アニメ名の後ろ4つは連番
				animation_name = animation_name.to_lower()
				
				var convname = conv_anim_name(animation_name) #特殊なBF、GFなどのアニメ名は辞書で正規化
				if convname != animation_name:
					animation_name = convname
					
				else: # 辞書にないパターン
					var no_anim = true
					if json: # jsonがあったらjsonのアニメ名を使う
						for i in json.animations:
							var orginal_fnf_name = i.name.to_lower().replace("!", "").replace("0", "")#謎仕様に対応
							if orginal_fnf_name == animation_name:
								animation_name = i.anim.to_lower()
								no_anim = false
								break
					if (!json) or no_anim: # jsonがないか、jsonに対応するアニメがない
						if not idle_f and animation_name.contains("idle"): # 特殊変換処理
							animation_name = "idle"
							
					if character != 0: #キャラクターだったら　アニメ名を正規化
						for anim in Game.note_anim:
							var i = anim.replace("2", "")
							if animation_name.contains(i):
								if animation_name.contains("dance"):
									animation_name = "dance" + i
								elif animation_name.contains("miss"):
									animation_name = "sing" + i + "miss"
								else:
									animation_name = "sing" + i
				
				if animation_name == "idle": #アイドルは１つのみ
					idle_f = true
				
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
					
					#var raw_frame_x:int
					#var raw_frame_y:int
					#raw_frame_x = xml.get_named_attribute_value("frameX").to_int()
					#raw_frame_y = xml.get_named_attribute_value("frameY").to_int()
				
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
				
				frames.add_frame(animation_name, frame_data)
				if play_animation_name == "":
					play_animation_name = animation_name
	
	#ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
	
	sprite_data.play(play_animation_name)
	
	return sprite_data


# XML load 3D kuso kuso kuso　コード　TODO 2Dから sprite.framesだけコピーすればいい
func load_XMLSprite3D(path, play_animation_name = "", loop_f = true, fps = 24, character = 0):
	if !FileAccess.file_exists(path):
		Audio.a_play("Error")
		printerr("invalid path. cannot load xml")
		var sprite = AnimatedSprite3D.new()
		var frames:SpriteFrames = SpriteFrames.new()
		frames.add_frame("default", Game.load_image("Assets/Images/UI/Missing.png"))
		sprite.frames = frames
		return sprite
		
	print("load xml sprite:", path)
	
	var sprite_data:AnimatedSprite3D = AnimatedSprite3D.new() 
	
	var base_path:StringName = path.get_basename()
	
	var texture:Texture = Game.load_image(base_path + ".png")
	
	var xml:XMLParser = XMLParser.new()
	xml.open(base_path + ".xml")
	
	var json: Dictionary
	if character == 1:
		json = p1_json
	elif character == 2:
		json = p2_json
	
	var frames:SpriteFrames = SpriteFrames.new() # アニメーションを管理 add_animationで追加
	
	sprite_data.frames = frames
	
	var idle_f = false
	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_TEXT:
			var node_name:StringName = xml.get_node_name()
			
			if node_name.to_lower() == "subtexture":
				var frame_data:AtlasTexture
				
				var animation_name = xml.get_named_attribute_value("name")
				animation_name = animation_name.left(len(animation_name) - 4) #アニメ名の後ろ4つは連番
				animation_name = animation_name.to_lower()
				
				var convname = conv_anim_name(animation_name) #特殊なBF、GFなどのアニメ名は辞書で正規化
				if convname != animation_name:
					animation_name = convname
					
				else: # 辞書にないパターン
					var no_anim = true
					if json: # jsonがあったらjsonのアニメ名を使う
						for i in json.animations:
							var orginal_fnf_name = i.name.to_lower().replace("!", "").replace("0", "")#謎仕様に対応
							if orginal_fnf_name == animation_name:
								animation_name = i.anim.to_lower()
								no_anim = false
								break
					if (!json) or no_anim: # jsonがないか、jsonに対応するアニメがない
						if not idle_f and animation_name.contains("idle"): # 特殊変換処理
							animation_name = "idle"
							
					if character != 0: #キャラクターだったら　アニメ名を正規化
						for i in Game.note_anim:
							if animation_name.contains(i):
								if animation_name.contains("dance"):
									animation_name = "dance" + i
								elif animation_name.contains("miss"):
									animation_name = "sing" + i + "miss"
								else:
									animation_name = "sing" + i
				
				if animation_name == "idle": #アイドルは１つのみ
					idle_f = true
				
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
					
					#var raw_frame_x:int
					#var raw_frame_y:int

					#raw_frame_x = xml.get_named_attribute_value("frameX").to_int()
					#raw_frame_y = xml.get_named_attribute_value("frameY").to_int()
				
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
				
				frames.add_frame(animation_name, frame_data)
				if play_animation_name == "":
					play_animation_name = animation_name
	
	#ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
	
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

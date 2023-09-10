extends Node2D

# BF, DAD, GFのアニメ

enum {PLAYER, DAD, GF}
@export var type: int = 0

var DEFAULT_XML = [
"Assets/Images/characters/BOYFRIEND.xml", 
"Assets/Images/characters/DADDY_DEAREST.xml", 
"Assets/Images/characters/GF_assets.xml"
]
const SPR_NAME = ["bf", "dad", "gf"]

@onready var bf = $bf

const note_anim: Array = ["singleft", "singdown", "singup", "singright"]
const miss_anim: Array = ["singleftmiss", "singdownmiss", "singupmiss", "singrightmiss"]
var idle_anim = "idle"

const GF_SP_DANCE_LEFT = "danceleft"
const GF_SP_DANCE_RIGHT = "danceright"

enum {IDLE = -1, NOTE, MISS}
var state: int = -1
var dir_2: int = 1

var animLength = 4.0
var animRemain: float = 0.0

var json: Dictionary
var offset_dic := {}
var loop_dic := {}

var xml_load_fail: bool = false
var json_load_fail: bool = false
var gf_beatanim_flag := false
var simple_anim := false

var offset3D := Vector2(75.0, -200.0)

var simple_anim_presets := {
	"left": 
		{"scale": [0, 0],
		"skew": -0.5},
	"up": 
		{"scale": [0, 0.5],
		"skew": 0},
	"down": 
		{"scale": [0, -0.5],
		"skew": 0},
	"right": 
		{"scale": [0, 0],
		"skew": 0.5}
}

func _ready():
	if Game.is3D:
		var bf3d = AnimatedSprite3D.new()
		bf.replace_by(bf3d)
		bf = bf3d
		setup3D()
	else:
		setup2D()

func setValue(setproperty, property, type = ""):
	var characterProperty = Game.character_property[Game.song_engine_type][property]
	if characterProperty == Game.SAME:
		characterProperty = Game.psych_character_property[property]
	elif characterProperty == Game.NULL:
		return
	if json.has(characterProperty):
		if type == "vector2":
			if json[characterProperty] is Array:
				setproperty = Vector2(json[characterProperty][0], json[characterProperty][1])
			else:
				setproperty = Vector2(json[characterProperty], json[characterProperty])
			return
		setproperty = json[characterProperty]
		return

func setup2D():
	var spr : AnimatedSprite2D
	var cam = $/root/Gameplay/Camera
	var gameplay = $/root/Gameplay
	
	if type == PLAYER: # BF側
		json = Game.p1_json # jsonにbfのjsonをいれる
		
		# 超絶分かりにくいfnfのpositionの仕様に仕方なく対応
		#position = Vector2(Game.stage.boyfriend[0], -Game.stage.boyfriend[1] * 2) + Vector2(json["position"][0], json["position"][1]) * json.scale
		position = Vector2(Game.stage.boyfriend[0], -Game.stage.boyfriend[1]) + Vector2(json["position"][0], json["position"][1]) * json.scale
		cam.bf = self # カメラの注視オブジェクトに自分をいれる
		json_load_fail = Game.bf_load_fail #chara jsonの読み出し失敗
		
	elif type == DAD: # DAD側
		json = Game.p2_json
		#position = Vector2(Game.stage.opponent[0], -Game.stage.opponent[1] * 2) + Vector2(json["position"][0], json["position"][1]) * json.scale
		position = Vector2(Game.stage.opponent[0], -Game.stage.opponent[1]) + Vector2(json["position"][0], json["position"][1]) * json.scale
		cam.dad = self
		json_load_fail = Game.dad_load_fail
		
	elif type == GF: # GF側
		gf_beatanim_flag = true
		json = Game.gf_json
		#position = Vector2(Game.stage.girlfriend[0], -Game.stage.girlfriend[1] * 2) + Vector2(json["position"][0], json["position"][1]) * json.scale
		position = Vector2(Game.stage.girlfriend[0], -Game.stage.girlfriend[1]) + Vector2(json["position"][0], json["position"][1]) * json.scale
		cam.gf = self
		gameplay.gf_strum_set(position)
		json_load_fail = Game.gf_load_fail
		
	if json.has("gf_special_anim"):
		gf_beatanim_flag = json.gf_special_anim
	if json.has("simpleAnimation"):
		simple_anim = json.simpleAnimation
		
	if Paths.p_chara_xml(json.image): # キャラクターのxmlが存在していたら
		spr = Game.load_XMLSprite(Paths.p_chara_xml(json.image), idle_anim, false, 24, type + 1)
		
	elif Game.chara_image_path:
		spr = Game.load_XMLSprite(Game.chara_image_path[type].replace(".png", ".xml"), idle_anim, false, 24, type + 1)
		
	else: # キャラクターのxmlが存在しない
		# エラー回避のためデフォルトを入れる
		spr = Game.load_XMLSprite(DEFAULT_XML[type], idle_anim, false, 24, type + 1)
		xml_load_fail = true
	setAnimLoop()
	#setValue(animLength, "sing_duration")
	animLength = json.sing_duration
	#setValue(spr.flip_h, "flip_x")
	spr.flip_h = json.flip_x
	spr.name = SPR_NAME[type]
	name = SPR_NAME[type] + "pos"
	#setValue(spr.scale, "scale", "vector2")
	spr.scale = Vector2(json.scale, json.scale)
	spr.centered = true
	
	# イレギュラー処理-------
	var atlastexture 
	
	if type == PLAYER:
		spr.flip_h = !json.flip_x # bfはflip_xの逆をflip_hに適用(分かりにくいfnfの仕様)
	if type == GF:
		spr.z_index = -1 # GFは奥にする
		
	if not spr.sprite_frames.has_animation(idle_anim):
		print("dont have idle name")
		idle_anim = "error"
		#if spr.sprite_frames.has_animation(note_anim[0]):
		#	idle_anim = note_anim[0] # idleがない場合はsingleftとする?
		#elif spr.sprite_frames.has_animation(GF_SP_DANCE_LEFT):
		#	idle_anim = GF_SP_DANCE_LEFT
		atlastexture = spr.sprite_frames.get_frame_texture(GF_SP_DANCE_LEFT, 0)
	else:
		atlastexture = spr.sprite_frames.get_frame_texture(idle_anim, 0)
		
	#----------------------
		
	bf.replace_by(spr)
	bf = spr
	if spr.sprite_frames.has_animation(idle_anim):
		bf.play(idle_anim)
	
	if json_load_fail or xml_load_fail: #キャラクターロード失敗
		loadFail(SPR_NAME[type], [json_load_fail, xml_load_fail])
		
	if atlastexture:
		var s = atlastexture.get_size()
		print("sp", atlastexture, s)
		
		#bf.offset += Vector2(s.x / 2.0, s.y / 2.0)
		position += Vector2(s.x / 2.0, s.y / 2.0)
	
	for i in json.animations:
		var psych_fnf_name = i.anim.to_lower()
		#offset_dic[psych_fnf_name] = -Vector2(i.offsets[0], i.offsets[1] / 2.0)
		offset_dic[psych_fnf_name] = -Vector2(i.offsets[0], i.offsets[1] / 2.0)
	#ResourceSaver.save(bf.sprite_frames, "Assets/Images/Characters/DADDY_DEAREST.res" , ResourceSaver.FLAG_COMPRESS)
	print(position, ", ", bf.offset, ", ", Vector2(Game.stage.boyfriend[0], Game.stage.boyfriend[1]), ", ", Vector2(Game.stage.opponent[0], Game.stage.opponent[1]), ", ", Vector2(json["position"][0], json["position"][1]))

func setup3D():
	var spr : AnimatedSprite3D
	var cam = $/root/Gameplay/Camera
	var gameplay = $/root/Gameplay
	
	if type == PLAYER: # BF側
		json = Game.p1_json # jsonにbfのjsonをいれる
		# 超絶分かりにくいfnfのpositionの仕様に仕方なく対応
		position = (Vector2(Game.stage.boyfriend[0], -Game.stage.boyfriend[1] * 2) + Vector2(json["position"][0], json["position"][1]))
		cam.bf = self # カメラの注視オブジェクトに自分をいれる
		json_load_fail = Game.bf_load_fail #chara jsonの読み出し失敗
		
	elif type == DAD: # DAD側
		json = Game.p2_json
		position = (Vector2(Game.stage.opponent[0], -Game.stage.opponent[1] * 2) + Vector2(json["position"][0], json["position"][1]))
		cam.dad = self
		json_load_fail = Game.dad_load_fail
		
	elif type == GF: # GF側
		json = Game.gf_json
		gf_beatanim_flag = true
		position = (Vector2(Game.stage.girlfriend[0], -Game.stage.girlfriend[1] * 2) + Vector2(json["position"][0], json["position"][1]))
		cam.gf = self
		gameplay.gf_strum_set(position)
		json_load_fail = Game.gf_load_fail
	
	if json.has("gf_special_anim"):
		gf_beatanim_flag = json.gf_special_anim
	
	if Paths.p_chara_xml(json.image): # キャラクターのxmlが存在していたら
		spr = Game.load_XMLSprite3D(Paths.p_chara_xml(json.image), idle_anim, false, 24, 2)
		
	else: # キャラクターのxmlが存在しない
		# エラー回避のためデフォルトを入れる
		spr = Game.load_XMLSprite3D(DEFAULT_XML[type], idle_anim, false, 24, 2)
		xml_load_fail = true
	
	animLength = json.sing_duration
	spr.flip_h = json.flip_x
	spr.name = SPR_NAME[type]
	name = SPR_NAME[type] + "pos"
	spr.scale = Vector3(json.scale, json.scale, json.scale)
	spr.sorting_offset += 4
	spr.position.z += 4
	spr.shaded = true
	
	# イレギュラー処理-------
	if type == PLAYER:
		spr.flip_h = !json.flip_x # bfはflip_xの逆をflip_hに適用(分かりにくいfnfの仕様)
	if type == GF:
		spr.sorting_offset -= 1 # GFは奥にする
		spr.position.z -= 1
		
	if not spr.sprite_frames.has_animation(idle_anim):
		print("dont have idle name")
		idle_anim = note_anim[0] # idleがない場合はsingleftとする?
	#----------------------
	
	bf.replace_by(spr)
	bf = spr
	bf.play(idle_anim)
	
	if json_load_fail or xml_load_fail: #キャラクターロード失敗
		loadFail(SPR_NAME[type], [json_load_fail, xml_load_fail])
		
	var atlastexture = bf.sprite_frames.get_frame_texture(idle_anim, 0)
	if atlastexture:
		var s = atlastexture.get_size()
		print("sp", atlastexture, s)
		
		bf.offset += Vector2(s.x / 2.0 / offset3D.x, s.y / 2.0 / offset3D.y)
	
	for i in json.animations:
		var psych_fnf_name = i.anim.to_lower()
		offset_dic[psych_fnf_name] = -Vector2(i.offsets[0] / offset3D.x, i.offsets[1] / 2.0 / offset3D.y)
	#ResourceSaver.save(bf.sprite_frames, "Assets/Images/Characters/DADDY_DEAREST.res" , ResourceSaver.FLAG_COMPRESS)
	print(position, ", ", bf.offset, ", ", Vector2(Game.stage.boyfriend[0], Game.stage.boyfriend[1]), ", ", Vector2(Game.stage.opponent[0], Game.stage.opponent[1]), ", ", Vector2(json["position"][0], json["position"][1]))

func getPosOffset():
	#position + offsetを返す カメラの位置計算に使う
	return position + bf.offset

func getScale():
	#キャラクターデータの中のscaleを返す カメラの位置計算に使う
	return json.scale

func getPosOffset3D():
	#position + offsetを返す カメラの位置計算に使う
	return Vector3((position.x + bf.offset.x) / offset3D.x, (position.y + bf.offset.y) / offset3D.y, 0.0)

func getCamOffset():
	if json.has("camera_position"):
		return Vector2(json.camera_position[0], json.camera_position[1])
	return Vector2.ZERO

func setOffset(animname : String):
	var offset3 := Vector2.ZERO
	for i in json["animations"]:
		if i.anim.to_lower() == animname and i.indices != []:
			bf.set_frame_and_progress(i.indices[0], 0.0)
			break
	if Game.is3D:
		offset3 = Vector2(position.x / offset3D.x, position.y / offset3D.y)
	if offset_dic.has(animname):
		bf.position.x = offset_dic[animname].x + offset3.x
		bf.position.y = offset_dic[animname].y + offset3.y
	else:
		bf.position.x = offset3.x
		bf.position.y = offset3.y

func setAnimLoop():
	for i in json["animations"]:
		loop_dic[i.anim.to_lower()] = i.loop

func animDirection(dir: int):
	dir_2 = dir
	
	state = NOTE
	
	var note_anim_name = multikey(dir)
	var animname = "sing" + note_anim_name
	if animRemain != 0:
		bf.stop()
	bf.play(animname)
	bf.sprite_frames.set_animation_loop(animname, false)
	
	setOffset(animname)
	
	animRemain = 60.0 / Audio.bpm * (animLength / 4.0)
	
	if simple_anim:
		bf.scale = Vector2(json.scale, json.scale)
		bf.skew = 0.0
		var simple_anim_scale = simple_anim_presets[note_anim_name].scale
		var simple_anim_skew = simple_anim_presets[note_anim_name].skew
		bf.scale.x += simple_anim_scale[0]
		bf.scale.y += simple_anim_scale[1]
		bf.skew += simple_anim_skew

func animDirectionMiss(dir: int):
	state = MISS
	
	var note_anim_name = multikey(dir)
	var animname = "sing" + note_anim_name + "miss"
	if animRemain != 0:
		bf.stop()
	bf.play(animname)
	bf.sprite_frames.set_animation_loop(animname, false)
	
	setOffset(animname)
	
	animRemain = 60.0 / Audio.bpm * (animLength / 4.0)

func multikey(direction):
	var note_anim_name = Game.note_anim[direction]
	if note_anim_name.contains("2"):
		note_anim_name = note_anim_name.replace("2", "")
	if note_anim_name.begins_with("r"):
		if note_anim_name == "right":
			pass
		elif note_anim_name == "rright":
			note_anim_name = "right"
		else:
			note_anim_name = note_anim_name.replace("r", "")
	if note_anim_name == "square":
		note_anim_name = "up"
	if note_anim_name == "plus":
		note_anim_name = "down"
	return note_anim_name

func _process(delta):
	if Game.cur_state == Game.NOT_PLAYING: return
	if Game.cur_state == Game.PAUSE:
		if bf.is_playing():
			bf.pause()
	else:
		if !bf.is_playing():
			bf.play()
	if bf.frame >= bf.sprite_frames.get_frame_count(bf.animation) - 1:
		if loop_dic.has(bf.animation):
			if not loop_dic[bf.animation]:
				bf.pause()
	if simple_anim:
		bf.scale = lerp(bf.scale, Vector2(json.scale, json.scale), 0.1)
		bf.skew = lerp(bf.skew, 0.0, 0.1)
	#if type == PLAYER:
	#	run_anim(delta)
	#elif type == DAD:
	#	run_anim(delta)
	#elif type == GF:
	
	run_anim(delta)

var beat := 0
func run_anim(delta):
	var input : Array
	if type == DAD:
		input = Game.dad_input
	elif type == GF:
		input = Game.gf_input
	else:
		input = Game.cur_input
		
	if input[dir_2] == 1:
		if bf.frame >= 3:
			bf.frame = 0
	else:
		if not Game.cur_state == Game.PAUSE:
			animRemain -= delta
	
	#inputCheck(input)
	for i in range(Game.key_count[type]):
		if input[i] == 2:
			# BOTやプレイヤー以外のときは入力を0に
			if type != PLAYER or (type == PLAYER and Setting.s_get("gameplay", "botplay")):
				input[i] = 0
			animDirection(i)
		
		if type == PLAYER and Game.bf_miss[i] == 1: #プレイヤーの場合ミスのアニメ
			Game.bf_miss[i] = 0
			animDirectionMiss(i)
			
	if animRemain <= 0: # アニメ終わった
		if gf_beatanim_flag: #gfの特殊パターン!!!
			if state != IDLE: 
				state = IDLE
				#bf.play(idle_anim[beat], 1.0, true)  #????
				#setOffset(idle_anim[beat])
			else:
				if Audio.beat_hit_event and Game.cur_state != Game.PAUSE:
					bf.stop()
					
					if bf.sprite_frames.has_animation(idle_anim): #idleがある
						bf.play(idle_anim, 1.0, true)
						setOffset(idle_anim)
						bf.frame = beat % 2 * 15 #GFのみ、アニメフレームを強制的にいじるHACK

					else: #idleがない
						if beat == 0:
							bf.play(GF_SP_DANCE_LEFT, 1.0, true)
						else:
							bf.play(GF_SP_DANCE_RIGHT, 1.0, true)
							var a : AnimatedSprite2D
						
					if beat == 0:
						beat = 1
					else:
						beat = 0	
						
		else:
			if state != IDLE: #アイドルアニメへ
				state = IDLE
				bf.play(idle_anim)
				setOffset(idle_anim)
			else:
				if Audio.beat_hit_bool:
					if loop_dic.has(idle_anim):
						if not loop_dic[idle_anim]:
							bf.stop()
							bf.play(idle_anim)
							setOffset(idle_anim)

var checking := false

func inputCheck(input):
	if checking: return
	checking = true
	for i in range(Game.key_count[type]):
		if input[i] == 2 or input[i] == 1:
			# BOTやプレイヤー以外のときは入力を0に
			if type != PLAYER or (type == PLAYER and Setting.s_get("gameplay", "botplay")):
				input[i] = 0
			animDirection(i)
		
		if type == PLAYER and Game.bf_miss[i] == 1: #プレイヤーの場合ミスのアニメ
			Game.bf_miss[i] = 0
			animDirectionMiss(i)
		await get_tree().create_timer(0).timeout
	checking = false
		

func loadFail(p_type, case):
	print(p_type, " load_fail ", case)
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_font_override("font", load("Assets/Fonts/vcr.ttf"))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_color_override("font_color", Color(1, 0, 0))
	label.add_theme_constant_override("outline_size", 5)
	label.position = bf.offset
	
	var p_name: String
	if p_type == "bf":
		p_name = Game.player1
	elif p_type == "dad":
		p_name = Game.player2
	elif p_type == "gf":
		p_name = Game.player3
	var count := 0
	for i in case:
		if i:
			count += 1
			if count == 1:
				label.text = "Character XML or JSON \"" + p_name + "\"\ndoes not exist."
			elif count == 2:
				label.text = "Character XML and JSON \"" + p_name + "\"\ndoes not exist."
	
	var shader: Shader = load("Assets/Shader/ChangeHue.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("saturation", 0)
	bf.set("material", shader_material)

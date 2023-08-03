extends Node2D

# BF, DAD, GFのアニメ

enum {PLAYER, DAD, GF}
@export var type: int = 0

var DEFAULT_XML = [
"res://Assets/Images/characters/BOYFRIEND.xml", 
"res://Assets/Images/characters/DADDY_DEAREST.xml", 
"res://Assets/Images/characters/GF_assets.xml"
]
var SPR_NAME = ["bf", "dad", "gf"]

@onready var bf : AnimatedSprite2D = $bf

var note_anim: Array = ["singleft", "singdown", "singup", "singright"]
var miss_anim: Array = ["singleftmiss", "singdownmiss", "singupmiss", "singrightmiss"]
var idle_anim = "idle"
var gf_anim = ["danceleft", "danceright"]

enum {IDLE = -1, NOTE, MISS}
var state: int = -1
var dir_2: int = 1

var animLength = 4.0
var animRemain: float = 0.0

var json: Dictionary
var offset_dic = {}

var xml_load_fail: bool = false
var json_load_fail: bool = false

func _ready():
	var spr : AnimatedSprite2D
	var cam = $/root/Gameplay/Camera
	
	if type == PLAYER: # BF側
		json = Game.p1_json # jsonにbfのjsonをいれる
		# 超絶分かりにくいfnfのpositionの仕様に仕方なく対応
		position = Vector2(Game.stage.boyfriend[0], -Game.stage.boyfriend[1] * 2) + Vector2(json["position"][0], json["position"][1])
		cam.bf = self # カメラの注視オブジェクトに自分をいれる
		json_load_fail = Game.bf_load_fail #chara jsonの読み出し失敗
		
	elif type == DAD: # DAD側
		json = Game.p2_json
		position = Vector2(Game.stage.opponent[0], -Game.stage.opponent[1] * 2) + Vector2(json["position"][0], json["position"][1])
		cam.dad = self
		json_load_fail = Game.dad_load_fail
		
	elif type == GF: # GF側
		json = Game.gf_json
		position = Vector2(Game.stage.girlfriend[0], -Game.stage.girlfriend[1] * 2) + Vector2(json["position"][0], json["position"][1])
		cam.gf = self
		json_load_fail = Game.gf_load_fail
		
	if Paths.p_chara_xml(json.image): # キャラクターのxmlが存在していたら
		spr = Game.load_XMLSprite(Paths.p_chara_xml(json.image), idle_anim, false, 24, 2)
		
	else: # キャラクターのxmlが存在しない
		# エラー回避のためデフォルトを入れる
		spr = Game.load_XMLSprite(DEFAULT_XML[type], idle_anim, false, 24, 2)
		xml_load_fail = true
		
	animLength = json.sing_duration
	spr.flip_h = json.flip_x
	spr.name = SPR_NAME[type]
	name = SPR_NAME[type] + "pos"
	spr.scale = Vector2(json.scale, json.scale)
	
	# イレギュラー処理-------
	if type == PLAYER:
		spr.flip_h = !json.flip_x # bfはflip_xの逆をflip_hに適用(分かりにくいfnfの仕様)
	if type == GF:
		spr.z_index = -1 # GFは奥にする
		
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
		
		bf.offset += Vector2(s.x / 2.0, s.y / 2.0)
	
	for i in json.animations:
		var psych_fnf_name = i.anim.to_lower()
		offset_dic[psych_fnf_name] = -Vector2(i.offsets[0], i.offsets[1] / 2.0)
	#ResourceSaver.save(bf.sprite_frames, "res://Assets/Images/Characters/DADDY_DEAREST.res" , ResourceSaver.FLAG_COMPRESS)
	print(position, ", ", bf.offset, ", ", Vector2(Game.stage.boyfriend[0], Game.stage.boyfriend[1]), ", ", Vector2(Game.stage.opponent[0], Game.stage.opponent[1]), ", ", Vector2(json["position"][0], json["position"][1]))

func getPosOffset():
	#position + offsetを返す カメラの位置計算に使う
	return position + bf.offset

func getScale():
	#キャラクターデータの中のscaleを返す カメラの位置計算に使う
	return json.scale

func setOffset(animname : String):
	for i in json["animations"]:
		if i.anim.to_lower() == animname and i.indices != []:
			bf.set_frame_and_progress(i.indices[0], 0.0)
			break
	if offset_dic.has(animname):
		bf.position = offset_dic[animname]
	else:
		bf.position = Vector2.ZERO
	

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
			
	if type == PLAYER:
		run_anim(delta)
	elif type == DAD:
		run_anim(delta)
	elif type == GF:
		gf_process(delta)

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
		animRemain -= delta
	for i in range(Game.key_count):
		if input[i] == 2:
			# BOTやプレイヤー以外のときは入力を0に
			if type != PLAYER or (type == PLAYER and Setting.s_get("gameplay", "botplay")):
				input[i] = 0
			animDirection(i)
		
		if type == PLAYER and Game.bf_miss[i] == 1: #プレイヤーの場合ミスのアニメ
			Game.bf_miss[i] = 0
			animDirectionMiss(i)
			
	if animRemain <= 0:
		if state != IDLE:
			state = IDLE
			bf.play(idle_anim)
			setOffset(idle_anim)
		else:
			if Audio.beat_hit_bool:
				bf.stop()
				bf.play(idle_anim)
				setOffset(idle_anim)


# アニメの速度をビートに合わせる計算をしていないのが原因では？？？
var beat := 0
func gf_process(delta):
	if Game.gf_input[dir_2] == 1:
		if bf.frame >= 3:
			bf.frame = 0
	else:
		animRemain -= delta
	for i in range(Game.key_count):
		if Game.gf_input[i] == 2:
			Game.gf_input[i] = 0
			animDirection(i)
	if animRemain <= 0:
		if state == IDLE: #idleのとき
			if Audio.beat_hit_event:
			#	bf.stop()
			#	bf.play(gf_anim[beat], 1.0, true) #??? これ機能してない・・・
			#	setOffset(gf_anim[beat])
				bf.stop()
				bf.play(idle_anim, 1.0, true)
				setOffset(idle_anim)
				bf.frame = beat % 2 * 15 #フレームを強制的にいじる？？しかし、modのときはどうするのか
				if beat == 0:
					beat = 1
				else:
					beat = 0
		else:
			state = IDLE
			bf.play(gf_anim[beat], 1.0, true)  #????
			setOffset(gf_anim[beat])			


func loadFail(p_type, case):
	print(p_type, " load_fail ", case)
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_font_override("font", load("res://Assets/Fonts/vcr.ttf"))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_color_override("font_color", Color(1, 0, 0))
	label.add_theme_constant_override("outline_size", 5)
	label.position = getPosOffset()
	
	
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
	
	var shader: Shader = load("res://Assets/Shader/ChangeHue.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("saturation", 0)
	bf.set("material", shader_material)

extends Node2D

enum {PLAYER, DAD, GF}
@export var type: int = 0

@onready var bf : AnimatedSprite2D = $bf

var note_anim: Array = ["singleft", "singdown", "singup", "singright"]
var miss_anim: Array = ["singleftmiss", "singdownmiss", "singupmiss", "singrightmiss"]
var idle_anim = "idle"

enum {IDLE = -1, NOTE, MISS}
var state: int = -1
var dir_2: int = 1

var animLength = 4.0
var animRemain: float = 0.0

var json :Dictionary
var offset_dic = {}

var load_fail: bool = false

func _ready():
	var spr : AnimatedSprite2D
	
	if type == PLAYER:
		json = Game.p1_json
		
		if FileAccess.file_exists("res://Assets/Images/" + json.image + ".xml"):
			spr = Game.load_XMLSprite("res://Assets/Images/" + json.image + ".xml", idle_anim, false, 24, 1)
		else:
			spr = Game.load_XMLSprite("res://Assets/Images/characters/BOYFRIEND.xml", idle_anim, false, 24, 1)
			load_fail = true
		spr.name = "bf"
		position = Vector2(Game.stage.boyfriend[0], Game.stage.boyfriend[1])# + Vector2(json["position"][0], json["position"][1])
		position += Vector2(400, 400)
		Game.p1_position = position
	elif type == DAD:
		json = Game.p2_json
		
		if FileAccess.file_exists("res://Assets/Images/" + json.image + ".xml"):
			spr = Game.load_XMLSprite("res://Assets/Images/" + json.image + ".xml", idle_anim, false, 24, 2)
		else:
			spr = Game.load_XMLSprite("res://Assets/Images/characters/DADDY_DEAREST.xml", idle_anim, false, 24, 2)
			load_fail = true
		spr.name = "dad"
		position = Vector2(Game.stage.opponent[0], Game.stage.opponent[1])# + Vector2(json["position"][0], json["position"][1])
		#psychの謎仕様として、characterのjsonのoffsetは読まない
		position += Vector2(400, 400)
		Game.p2_position = position
	animLength = json.sing_duration
	bf.replace_by(spr)
	bf = spr
	print(position)
	bf.play(idle_anim)
	
	if load_fail or Game.character_load_fail:
		loadFail()
	
	var atlastexture = bf.sprite_frames.get_frame_texture(idle_anim, 0)
	if atlastexture:
		var s = atlastexture.get_size()
		print("sp", atlastexture, s)
		
		bf.offset = -Vector2(s.x / 2, s.y / 2)
	
	for i in json.animations:
		var psych_fnf_name = i.anim.to_lower()
		offset_dic[psych_fnf_name] = -Vector2(i.offsets[0], i.offsets[1] * 0.5)
	#ResourceSaver.save(bf.sprite_frames, "res://Assets/Images/Characters/DADDY_DEAREST.res" , ResourceSaver.FLAG_COMPRESS)
	
func setOffset(animname : String):
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
		player_process(delta)
	if type == DAD:
		dad_process(delta)

func player_process(delta):
	if Game.cur_input[dir_2] == 1:
		if bf.frame >= 3:
			bf.frame = 0
	else:
		animRemain -= delta
	for i in range(Game.key_count):
		if Game.cur_input[i] == 2 or Game.cur_input_sub[i] == 2:
			if Setting.s_get("gameplay", "botplay"):
				Game.cur_input[i] = 0
			animDirection(i)
		if Game.bf_miss[i] == 1:
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

func dad_process(delta):
	if Game.dad_input[dir_2] == 1:
		if bf.frame >= 3:
			bf.frame = 0
	else:
		animRemain -= delta
	for i in range(Game.key_count):
		if Game.dad_input[i] == 2:
			Game.dad_input[i] = 0
			animDirection(i)
	if animRemain <= 0:
		if state != IDLE:
			state = IDLE
			bf.play(idle_anim, 1.0, true)
			setOffset(idle_anim)
		else:
			if Audio.beat_hit_bool:
				bf.stop()
				bf.play(idle_anim, 1.0, true)
				setOffset(idle_anim)

func loadFail():
	print("fail")
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_font_override("font", load("res://Assets/Fonts/vcr.ttf"))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_color_override("font_color", Color(1, 0, 0))
	label.add_theme_constant_override("outline_size", 5)
	if type == PLAYER:
		label.text = "Character \"" + Game.player1 + "\"\ndoes not exist"
	elif type == DAD:
		label.text = "Character \"" + Game.player2 + "\"\ndoes not exist"
	label.position = bf.position - Vector2(400, 400)
	bf.add_child(label)
	
	var shader: Shader = load("res://Assets/Shader/ChangeHue.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("saturation", 0)
	bf.set("material", shader_material)

#"""
## VARIABLES #
#@onready var sprite_data:AnimatedSprite2D = $"../SpriteData"
#@onready var fps_box:LineEdit = $FPS
#
#var path:StringName = "res://Assets/Images/Characters/bf"
#var fps:int = 24
#var looped:bool = false
#var optimized:bool = true
#
#func convert_xml() -> void:
#	if path == "":
#		return
#
#	var base_path:StringName = path.get_basename()
#	var texture:Texture = load(base_path + ".png")
#
#	if texture == null:
#		print(base_path + " loading failed.")
#		return
#
#	var frames:SpriteFrames = SpriteFrames.new()
#	frames.remove_animation("default")
#
#	var xml:XMLParser = XMLParser.new()
#	xml.open(base_path + ".xml")
#
#	sprite_data.frames = frames
#
#	var previous_atlas:AtlasTexture
#	var previous_rect:Rect2
#
#	while xml.read() == OK:
#		if xml.get_node_type() != XMLParser.NODE_TEXT:
#			var node_name:StringName = xml.get_node_name()
#
#			if node_name.to_lower() == "subtexture":
#				var frame_data:AtlasTexture
#
#				var animation_name = xml.get_named_attribute_value("name")
#				animation_name = animation_name.left(len(animation_name) - 4)
#
#				var frame_rect:Rect2 = Rect2(
#					Vector2(
#						xml.get_named_attribute_value("x").to_float(),
#						xml.get_named_attribute_value("y").to_float()
#					),
#					Vector2(
#						xml.get_named_attribute_value("width").to_float(),
#						xml.get_named_attribute_value("height").to_float()
#					)
#				)
#
#				if optimized and previous_rect == frame_rect:
#					frame_data = previous_atlas
#				else:
#					frame_data = AtlasTexture.new()
#					frame_data.atlas = texture
#					frame_data.region = frame_rect
#
#					if xml.has_attribute("frameX"):
#						var margin:Rect2
#
#						var raw_frame_x:int = xml.get_named_attribute_value("frameX").to_int()
#						var raw_frame_y:int = xml.get_named_attribute_value("frameY").to_int()
#
#						var raw_frame_width:int = xml.get_named_attribute_value("frameWidth").to_int()
#						var raw_frame_height:int = xml.get_named_attribute_value("frameHeight").to_int()
#
#						var frame_size_data:Vector2 = Vector2(
#							raw_frame_width,
#							raw_frame_height
#						)
#
#						if frame_size_data == Vector2.ZERO:
#							frame_size_data = frame_rect.size
#
#						margin = Rect2(Vector2(-raw_frame_x, -raw_frame_y),
#								Vector2(raw_frame_width - frame_rect.size.x,
#										raw_frame_height - frame_rect.size.y)
#						)
#
#						if margin.size.x < abs(margin.position.x):
#							margin.size.x = abs(margin.position.x)
#						if margin.size.y < abs(margin.position.y):
#							margin.size.y = abs(margin.position.y)
#
#						frame_data.margin = margin
#
#					frame_data.filter_clip = true
#
#					previous_atlas = frame_data
#					previous_rect = frame_rect
#
#				if not frames.has_animation(animation_name):
#					frames.add_animation(animation_name)
#					frames.set_animation_loop(animation_name, looped)
#					frames.set_animation_speed(animation_name, fps)
#
#				frames.add_frame(animation_name, frame_data)
#
#	ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
#
#	var framerate_multiplier:float = (1.0 / fps)
#
#	for anim in frames.animations:
#		sprite_data.play(anim.name)
#
#		await get_tree().create_timer(framerate_multiplier * frames.get_frame_count(anim.name))\
#				.timeout
#
#func _ready() -> void:
#	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	convert_xml()
#
## funny signal shits
#func set_path(new_path:StringName) -> void:
#	path = new_path
#
#func set_fps(new_fps:StringName) -> void:
#	fps = new_fps.to_int()
#
#func set_looped(new_looped:bool) -> void:
#	looped = new_looped
#
#func set_optimized(new_optimized:bool) -> void:
#	optimized = new_optimized
#"""

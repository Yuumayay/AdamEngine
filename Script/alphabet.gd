extends Node2D

@export var text: String
@export_enum("Normal", "Bold") var type := 0
@export_enum("Left", "Center", "Right") var grow_direction_h := 2
var width: float
var value: int
var string: String
var array: Array
var color: Color

var conv_name: Dictionary = {"\'": "apostrophe", ".": "period"}

var last_text: String
var last_type: int
var alphabet

signal text_ready

func _process(_delta):
	if text != last_text or type != last_type:
		property_changed()
		last_text = text
		last_type = type

func conv_text_name(i):
	#print(conv_name.get(i))
	if conv_name.get(i):
		return conv_name.get(i)
	return i

func _ready():
	alphabet = Game.load_XMLSprite("Assets/Images/Skins/FNF/Alphabet/alphabet.png")
	#while true:
	#	for i in get_children():
	#		if i is Sprite2D:
	#			if i.frame == 1:
	#				i.frame = 0
	#			else:
	#				i.frame = 1
	#	await get_tree().create_timer(0.1).timeout

func property_changed():
		var total_x := 0.0
		var total_y := 0.0
		for i in get_children():
			if i is AnimatedSprite2D:
				remove_child(i)
		for i in text.length():
			var sprite: AnimatedSprite2D = alphabet.duplicate()
			var text_name = conv_text_name(text[i])
			var tex_width
			var anim_name
			var lower = text_name.to_lower()
			if type == 0:
				if text_name == " ":
					total_x += 50
					sprite.hide()
				elif text_name == "\n":
					total_x = 0
					total_y += 50
					sprite.hide()
				elif text_name == lower:
					anim_name = lower + " lowercase instance 1"
					if not sprite.sprite_frames.has_animation(anim_name):
						anim_name = lower + " normal instance 1"
					sprite.play(anim_name)
				else:
					anim_name = lower + " uppercase instance 1"
					sprite.play(anim_name)
			elif type == 1:
				if text_name == " ":
					total_x += 50
					sprite.hide()
				elif text_name == "\n":
					total_x = 0
					total_y += 50
					sprite.hide()
				else:
					anim_name = lower + " bold instance 1"
					sprite.play(anim_name)
			sprite.centered = false
			sprite.offset.y += 50
			sprite.position.x = total_x
			sprite.position.y = total_y
			sprite.name = "Sprite"
			#sprite.position.y -= 150 / 2
			if text_name != "\n" and text_name != " ":
				total_x += sprite.sprite_frames.get_frame_texture(anim_name, 0).get_width()
				if type == 0:
					sprite.position.y += (sprite.sprite_frames.get_frame_texture(anim_name, 0).get_height()) / 2.0 * -1
			add_child(sprite)
		if grow_direction_h == 0:
			for i in get_children():
				if i is AnimatedSprite2D:
					i.position.x -= total_x
		elif grow_direction_h == 1:
			for i in get_children():
				if i is AnimatedSprite2D:
					i.position.x -= total_x / 2.0
		width = total_x
		emit_signal("text_ready")

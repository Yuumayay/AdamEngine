extends Node2D

@export var text: String
@export_enum("Normal", "Bold") var type := 0
@export_enum("Left", "Center", "Right") var grow_direction_h := 2
@export var width: float
@export var value: int

var last_text: String
var last_type: int

func _process(delta):
	if text != last_text or type != last_type:
		property_changed()
		last_text = text
		last_type = type

func _ready():
	pass
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
			if i is Sprite2D:
				remove_child(i)
		for i in text.length():
			var sprite = Sprite2D.new()
			var text_name = text[i]
			if type == 0:
				var lower = text_name.to_lower()
				if text_name == " ":
					total_x += 50
				elif text_name == "\n":
					total_x = 0
					total_y += 50
				elif text_name == lower:
					if FileAccess.file_exists("res://Assets/Images/alphabet/" + text_name.to_upper() + " LOWERCASE.png"):
						sprite.texture = load("res://Assets/Images/alphabet/" + text_name.to_upper() + " LOWERCASE.png")
					else:
						sprite.texture = load("res://Assets/Images/alphabet/" + text_name.to_upper() + ".png")
				else:
					sprite.texture = load("res://Assets/Images/alphabet/" + text_name.to_upper() + ".png")
			elif type == 1:
				if text_name == " ":
					total_x += 50
				elif text_name == "\n":
					total_x = 0
					total_y += 50
				else:
					sprite.texture = load("res://Assets/Images/alphabet/" + text_name.to_upper() + " BOLD.png")
			sprite.centered = true
			sprite.hframes = 2
			sprite.position.x = total_x
			sprite.position.y = total_y
			sprite.name = "Sprite"
			#sprite.position.y -= 150 / 2
			if text_name != "\n" and text_name != " ":
				total_x += sprite.texture.get_width() / 2.0 + 2.0
			add_child(sprite)
		if grow_direction_h == 0:
			for i in get_children():
				if i is Sprite2D:
					i.position.x -= total_x
		elif grow_direction_h == 1:
			for i in get_children():
				if i is Sprite2D:
					i.position.x -= total_x / 2.0
		width = total_x

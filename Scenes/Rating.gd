extends AnimatedSprite2D

var y_speed = -1
var x_speed = randf_range(-2.0, 2.0)
var num = [preload("res://Assets/Images/Skins/FNF/Numbers/num0.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num1.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num2.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num3.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num4.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num5.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num6.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num7.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num8.png"),
preload("res://Assets/Images/Skins/FNF/Numbers/num9.png")]

func _ready():
	var ind := 0
	if str(Game.combo).length() <= 3:
		for i in abs(str(Game.combo).length() - 3):
			var new_num = Sprite2D.new()
			new_num.texture = num[0]
			new_num.position.x = ind * 50 - 100
			new_num.position.y = -100
			new_num.scale = Vector2(0.5,0.5)
			ind += 1
			add_child(new_num)
		for i in str(Game.combo).length():
			var new_num = Sprite2D.new()
			new_num.texture = num[str(Game.combo).substr(i, 1).to_int()]
			new_num.position.x = ind * 50 - 100
			new_num.position.y = -100
			new_num.scale = Vector2(0.5,0.5)
			ind += 1
			add_child(new_num)
	else:
		for i in str(Game.combo).length():
			var new_num = Sprite2D.new()
			new_num.texture = num[str(Game.combo).substr(i, 1).to_int()]
			new_num.position.x = ind * 50 - 100
			new_num.position.y = -100
			new_num.scale = Vector2(0.5,0.5)
			ind += 1
			add_child(new_num)

func _process(delta):
	y_speed += delta * (Audio.bpm / 40.0)
	position.y += y_speed
	position.x += x_speed
	modulate.a -= delta * (Audio.bpm / 100.0)
	if modulate.a <= 0:
		get_parent().queue_free()

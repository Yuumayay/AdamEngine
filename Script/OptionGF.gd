extends AnimatedSprite2D

var last_x := 0.0
var last_y := 0.0
var og_x := 0.0
var gf_petting_frame := 0

func _ready():
	og_x = position.x
	var rect = ColorRect.new()
	rect.position.x = -100
	rect.position.y = -150
	rect.size.x = 200
	rect.size.y = 100
	rect.name = "rect"
	rect.mouse_entered.connect(enter)
	rect.mouse_exited.connect(exit)
	rect.modulate.a = 0
	add_child(rect)

var pet_timer := 0.0

func _process(delta):
	var mouse_x = get_global_mouse_position().x
	var mouse_y = get_global_mouse_position().y
	var x_speed = abs(mouse_x - last_x)
	var y_speed = abs(mouse_x - last_y)
	var raw_x_speed = mouse_x - last_x
	print(x_speed, ", ", y_speed)
	if x_speed >= 5 and entered:
		pet_timer = 1.0
		if animation != "girlfriend :raised_eyeborw:":
			if not Audio.has_node("gf_petting"):
				var gfsound = AudioStreamPlayer.new()
				gfsound.stream = load("Assets/Sounds/gf_petting.ogg")
				gfsound.name = "gf_petting"
				Audio.add_child(gfsound)
			play("girlfriend :raised_eyeborw:")
		else:
			if Game.gf_pet_total < 30.0:
				gf_petting_frame = 0
			elif Game.gf_pet_total < 60.0:
				gf_petting_frame = 1
			else:
				gf_petting_frame = 2
			if not Audio.a_check("gf_petting"):
				Audio.a_play("gf_petting", 0.5)
			Audio.a_volume_set("gf_petting", clamp(x_speed, 0, 20) / 10.0 - 10)
			Game.gf_pet_total += delta
			raw_x_speed = clamp(raw_x_speed, -20, 20)
			skew = lerp(skew, raw_x_speed / 360.0, 0.1)
			position.x = lerp(position.x, og_x + raw_x_speed, 0.1)
			frame = gf_petting_frame
	else:
		if Audio.has_node("gf_petting"):
			if entered:
				Audio.a_volume_set("gf_petting", x_speed - 20)
			else:
				Audio.a_stop("gf_petting")
		pet_timer -= delta
		if animation == "girlfriend :raised_eyeborw:":
			frame = gf_petting_frame
			if pet_timer <= 0.0:
				Audio.a_stop("gf_petting")
				play("girlfriend neutral")
				stop()
		else:
			skew = lerp(skew, 0.0, 0.1)
			position.x = lerp(position.x, og_x, 0.1)
	last_x = mouse_x
	last_y = mouse_y

var entered := false

func enter():
	entered = true

func exit():
	entered = false

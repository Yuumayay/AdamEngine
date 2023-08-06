extends Control

var layer: int = 0
var select: int = 0
var child_count: int = 0
var select2: int = 0
var child_count2: int = 0
var canvas: CanvasLayer
var db: float

func _ready():
	child_count = get_child_count() - 1
	canvas = get_parent().get_parent()
	Audio.a_play("Pause Menu", 1.0, -10)
	Audio.get_node("Pause Menu").volume_db = -20
	db = Audio.get_node("Pause Menu").volume_db
	
	if Setting.s_get("gameplay", "downscroll"):
		get_node("Downscroll").text = "downscroll"
	else:
		get_node("Downscroll").text = "upscroll"
	
	if Setting.s_get("gameplay", "botplay"):
		get_node("Botplay").text += " on"
	else:
		get_node("Botplay").text += " off"
	if Setting.s_get("gameplay", "practice"):
		get_node("Practice").text += " on"
	else:
		get_node("Practice").text += " off"
		
	if !Setting.eng():
		for i in get_children():
			i.add_theme_font_override("font", load("res://Assets/Fonts/DarumadropOne-Regular.ttf"))
			i.add_theme_font_size_override("font_size", 100)
			i.add_theme_constant_override("outline_size", 25)
			i.add_theme_color_override("font_outline_color", Color(0, 0, 0))
			i.text = Setting.translate(i.text)

func _process(delta):
	if db <= 0:
		Audio.a_volume_add("Pause Menu", delta)
		db = Audio.get_node("Pause Menu").volume_db
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if layer == 0:
				if select == 0:
					select = child_count
				else:
					select -= 1
			else:
				if select2 == 0:
					select2 = child_count2
				else:
					select2 -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if layer == 0:
				if select == child_count:
					select = 0
				else:
					select += 1
			else:
				if select2 == child_count2:
					select2 = 0
				else:
					select2 += 1
		if Input.is_action_just_pressed("ui_accept"):
			match get_child(select).name:
				"Resume":
					Audio.a_resume("Inst")
					Audio.a_resume("Voices")
					Audio.a_stop("Pause Menu")
					canvas.queue_free()
					if Audio.cur_ms < 0.0:
						canvas.get_parent().get_node("timer").paused = false
						canvas.get_parent().get_node("countDownTimer").paused = false
						Game.cur_state = Game.COUNTDOWN
					else:
						Game.cur_state = Game.PLAYING
				"Restart":
					Audio.a_stop("Pause Menu")
					canvas.get_parent().moveSong(Game.cur_song)
					canvas.queue_free()
				"Difficulty":
					for i in get_children():
						remove_child(i)
					for i in Game.difficulty:
						var label = Label.new()
						label.text = i
						label.uppercase = true
						label.add_theme_font_override("font", load("res://Assets/Fonts/alphabet.png"))
						add_child(label)
					child_count2 = get_child_count() - 1
				"Downscroll":
					Setting.s_set("gameplay", "downscroll", !Setting.s_get("gameplay", "downscroll"))
					if Setting.s_get("gameplay", "downscroll"):
						get_node("Downscroll").text = "downscroll"
					else:
						get_node("Downscroll").text = "upscroll"
					if !Setting.eng():
						get_node("Downscroll").text = Setting.translate(get_node("Downscroll").text)
					canvas.get_parent().strum_set()
					canvas.get_parent().note_pos_set()
					canvas.get_parent().get_node("UI/HealthBarBG").updatePos()
					canvas.get_parent().get_node("Info").updatePos()
					canvas.get_parent().get_node("UI/ColorRect/TimeBar").updatePos()
				"Botplay":
					Setting.s_set("gameplay", "botplay", !Setting.s_get("gameplay", "botplay"))
					if Setting.s_get("gameplay", "botplay"):
						get_node("Botplay").text = "botplay on"
					else:
						get_node("Botplay").text = "botplay off"
					if !Setting.eng():
						get_node("Botplay").text = Setting.translate(get_node("Botplay").text)
					canvas.get_parent().strum_set()
				"Practice":
					Setting.s_set("gameplay", "practice", !Setting.s_get("gameplay", "practice"))
					if Setting.s_get("gameplay", "practice"):
						get_node("Practice").text = "practice on"
					else:
						get_node("Practice").text = "practice off"
					if !Setting.eng():
						get_node("Practice").text = Setting.translate(get_node("Practice").text)
				"Back":
					Audio.a_stop("Inst")
					Audio.a_stop("Voices")
					Audio.a_stop("Pause Menu")
					canvas.get_parent().quit()
					canvas.queue_free()
		if Input.is_action_just_pressed("ui_cancel"):
			Game.cur_state = Game.PLAYING
			Audio.a_resume("Inst")
			Audio.a_resume("Voices")
			canvas.queue_free()
	update_position()
# Called when the node enters the scene tree for the first time.
func update_position():
	for i in get_children():
		i.position.x = lerp(i.position.x, abs(select - i.get_index()) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (275.0 + i.get_index() * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.get_index()) / 5.0, 0.25)

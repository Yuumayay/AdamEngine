extends Control

var select: int = 0
var child_count: int = 0
var canvas: CanvasLayer

func _ready():
	child_count = get_child_count() - 1
	canvas = get_parent().get_parent()

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if select == 0:
				select = child_count
			else:
				select -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
		if Input.is_action_just_pressed("ui_accept"):
			match get_child(select).name:
				"Resume":
					Game.cur_state = Game.PLAYING
					Audio.a_resume("Inst")
					Audio.a_resume("Voices")
				"Restart":
					Audio.a_resume("Inst")
					Audio.a_resume("Voices")
					canvas.get_parent().restart()
				"Back":
					Audio.a_stop("Inst")
					Audio.a_stop("Voices")
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

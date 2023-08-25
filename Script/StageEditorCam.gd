extends Camera2D

const zoom_up_value := 1.1
const zoom_down_value := 0.9

@onready var parent = get_parent()

func _process(_delta):
	if parent.can_input:
		if Input.is_action_just_pressed("game_scroll_up"):
			zoom *= zoom_up_value
		if Input.is_action_just_pressed("game_scroll_down"):
			zoom *= zoom_down_value

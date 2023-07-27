extends CanvasLayer

@onready var rect: ColorRect = $Rect

func flash(color: Color, duration: float):
	visible = true
	rect.color = Color(1, 1, 1, 1)
	var t = get_tree().create_tween()
	t.tween_property(rect, "modulate", color, duration)
	t.play()
	t.tween_callback(func(): visible = false)

func _process(_delta):
	if Game.trans:
		visible = false

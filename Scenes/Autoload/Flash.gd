extends CanvasLayer

@onready var rect: ColorRect = $Rect

func flash(color = Color(1, 1, 1, 1), duration = 0.5):
	visible = true
	rect.color = color
	var t = get_tree().create_tween()
	t.tween_property(rect, "color", Color(color.r, color.g, color.b, 0), duration)
	t.play()
	t.tween_callback(func(): visible = false)

func _process(_delta):
	if Game.trans:
		visible = false

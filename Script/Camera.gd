extends Camera2D

func _process(_delta):
	if Game.mustHit:
		position = lerp(position, Game.p1_position + Vector2(-400, -300), 0.05)
	else:
		position = lerp(position, Game.p2_position + Vector2(0, -400), 0.05)

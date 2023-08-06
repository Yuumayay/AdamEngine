extends Camera2D

var beat := 0

func _process(_delta):
	zoom = lerp(zoom, Vector2(1, 1), 0.1)
	position = lerp(position, Vector2(640, 360), 0.1)
	if floor(int(Audio.a_get_beat("Debug Menu", 1)) / 16) % 2 == 1:
		if beat != Audio.a_get_beat("Debug Menu", 4) * 10:
			beat = Audio.a_get_beat("Debug Menu", 4) * 10
			if beat % 20 == 0:
				zoom = Vector2(1.5, 1.5)
				scale = Vector2(2, 1)
				position.x += 500
			else:
				zoom = Vector2(0.75, 0.75)
				scale = Vector2(1, 2)
				position.x -= 500
	else:
		if beat != Audio.a_get_beat("Debug Menu", 1) * 10:
			beat = Audio.a_get_beat("Debug Menu", 1) * 10
			zoom = Vector2(1.1, 1.1)
			scale = Vector2(1, 1)
			if beat % 20 == 0:
				position.x += 100
			else:
				position.x -= 100

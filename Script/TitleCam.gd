extends Camera2D

var beat := 0

const zoom_offset = Vector2(1.05, 1.05)

func _process(delta):
	zoom = lerp(zoom, Vector2(1, 1), 0.1)
	if Audio.a_check("Freaky Menu"):
		var cur_beat = Audio.a_get_beat("Freaky Menu", 4)
		if beat != cur_beat:
			beat = cur_beat
			zoom = zoom_offset
	else:
		var cur_beat = Audio.a_get_beat("Option Menu", 2)
		if beat != cur_beat:
			beat = cur_beat
			zoom = zoom_offset

extends RichTextLabel

var beat := 0

var adam := ["A", "D", "M"]

func _process(_delta):
	scale = lerp(scale, Vector2(5, 5), 0.1)
	position = lerp(position, Vector2(295, 27), 0.1)
	if floor(int(Audio.a_get_beat("Debug Menu", 1)) / 16) % 2 == 1:
		if beat != Audio.a_get_beat("Debug Menu", 2) * 10:
			beat = Audio.a_get_beat("Debug Menu", 2) * 10
			scale = Vector2(2, 2)
			var random_adam: String
			for i in range(14):
				random_adam += adam[randi_range(0, 2)]
			text = "[shake rate=10 level=200]" + random_adam + "[/shake]"
			if beat % 20 == 0:
				position.y += 300
			else:
				position.y -= 300
	else:
		if beat != Audio.a_get_beat("Debug Menu", 1) * 10:
			beat = Audio.a_get_beat("Debug Menu", 1) * 10
			scale = Vector2(1.1, 1.1)
			text = "[shake rate=10 level=20]THE DEBUG MENU[/shake]"
			if beat % 20 == 0:
				position.y += 100
			else:
				position.y -= 100

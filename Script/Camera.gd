extends Camera2D

var beat := 0

func _process(_delta):
	zoom = lerp(zoom, Vector2(Game.defaultZoom, Game.defaultZoom), 0.1)
	if Game.mustHit:
		position = lerp(position, Game.p1_position + Vector2(-400, -300), 0.05)
	else:
		position = lerp(position, Game.p2_position + Vector2(0, -400), 0.05)
	if beat != Audio.cur_section:
		beat = Audio.cur_section
		zoom = Vector2(Game.defaultZoom + 0.025, Game.defaultZoom + 0.025)

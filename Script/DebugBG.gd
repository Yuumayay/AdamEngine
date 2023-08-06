extends Sprite2D

@export var og_scale: Vector2 = Vector2(1, 1)
@export var bumpin_scale: Vector2 = Vector2(1.25, 1.25)
@export var bumpin_speed: float = 0.25
@export var music_div: int = 4
@export var what_music: String = "Debug Menu"

var beat := 0

func _ready():
	scale = og_scale

func _process(_delta):
	scale = lerp(scale, Vector2(1, 1), 0.1)
	position = lerp(position, Vector2(640, 360), 0.1)
	if floor(int(Audio.a_get_beat("Debug Menu", 1)) / 16) % 2 == 1:
		if beat != Audio.a_get_beat("Debug Menu", 4) * 10:
			modulate = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))
			beat = Audio.a_get_beat("Debug Menu", 4) * 10
			scale = Vector2(1.1, 1.1)
			if beat % 20 == 0:
				#position.x -= 300
				pass
			else:
				#position.x += 300
				pass
	else:
		if beat != Audio.a_get_beat("Debug Menu", 1) * 10:
			modulate = Color(1, 1, 1)
			rotation = 0
			beat = Audio.a_get_beat("Debug Menu", 1) * 10
			scale = Vector2(1.1, 1.1)
			if beat % 20 == 0:
				position.x -= 100
			else:
				position.x += 100

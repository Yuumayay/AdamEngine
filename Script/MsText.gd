extends Label

@export var ms: float

var hit: float

func _ready():
	if Setting.s_get("graphics", "show ms"):
		show()
	hit = Game.total_hit
	text = str(floor(ms * 100.0) / 100.0) + " ms"
	if ms == 0.0:
		modulate = Color(1, 1, 0)
	elif ms < 0.0:
		modulate = Color(0, 1, 1)
	else:
		modulate = Color(1, 0.5, 0)

func _process(delta):
	modulate.a -= delta * (Audio.bpm / 50.0)
	if modulate.a <= 0 or hit != Game.total_hit:
		queue_free()

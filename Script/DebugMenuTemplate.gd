extends RichTextLabel

@export var ind: int
@export var og_scale: Vector2 = Vector2(1, 1)
@export var bumpin_scale: Vector2 = Vector2(1.25, 1.25)
@export var bumpin_speed: float = 0.25
@export var music_div: int = 4
@export var what_music: String = "Debug Menu"

var beat = 0

func _ready():
	scale = og_scale

func _process(_delta):
	scale = lerp(scale, og_scale, bumpin_speed)
	if what_music == "Inst":
		if beat != Audio.cur_beat:
				scale = bumpin_scale
				beat = Audio.cur_beat
	else:
		if beat != Audio.a_get_beat(what_music, music_div):
				scale = bumpin_scale
				beat = Audio.a_get_beat(what_music, music_div)

func accepted(selected: bool):
	var t = get_tree().create_tween()
	if selected:
		t.tween_property(self, "scale", Vector2(1, 1), 0.1)
		for i in range(10):
			modulate = Color(1, 1, 1, 0)
			await get_tree().create_timer(0.05).timeout
			modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.05).timeout
		Trans.t_trans(name)
	else:
		t.tween_property(self, "position", Vector2(position.x + 100, position.y), 0.25)
		t.tween_property(self, "position", Vector2(-2000, position.y), 0.25)
		t.set_trans(Tween.TRANS_QUINT)
		t.set_ease(Tween.EASE_IN)

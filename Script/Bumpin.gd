extends Sprite2D

@export var og_scale: Vector2 = Vector2(1, 1)
@export var bumpin_scale: Vector2 = Vector2(1.25, 1.25)
@export var bumpin_speed: float = 0.25
@export var music_div: int = 4
@export var what_music: String = "Freaky Menu"
@export var load_img: String = ""

var beat = 0
var ind = 0

func _ready():
	if load_img != "":
		texture = Game.load_image(load_img)
	scale = og_scale

func _process(_delta):
	scale = lerp(scale, og_scale, bumpin_speed)
	if what_music == "Inst":
		if beat != Audio.cur_beat:
				ind += 1
				scale = bumpin_scale
				beat = Audio.cur_beat
	else:
		if beat != Audio.a_get_beat(what_music, music_div):
				ind += 1
				scale = bumpin_scale
				beat = Audio.a_get_beat(what_music, music_div)

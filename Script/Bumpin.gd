extends Sprite2D

@export var og_scale: Vector2 = Vector2(1, 1)
@export var bumpin_scale: Vector2 = Vector2(1.25, 1.25)
@export var bumpin_speed: float = 0.25
@export var music_div: int = 1
@export var what_music: String = "Freaky Menu"

var beat = 0
var ind = 0

var music_offset = File.f_read(Paths.p_offset("Music/Offset.json"), ".json")
var bpm = music_offset.MenuMusic[1]

func _ready():
	scale = og_scale

func _process(_delta):
	scale = lerp(scale, og_scale, bumpin_speed)
	if what_music == "Freaky Menu":
		if beat != Audio.a_get_beat(what_music, bpm, music_div):
			if ind == 0:
				ind += 1
				beat = Audio.a_get_beat(what_music, bpm, music_div)
			else:
				ind += 1
				scale = bumpin_scale
				beat = Audio.a_get_beat(what_music, bpm, music_div)
	if what_music == "Inst":
		if beat != Audio.cur_beat:
			if ind == 0:
				ind += 1
				beat = Audio.cur_beat
			else:
				ind += 1
				scale = bumpin_scale
				beat = Audio.cur_beat

extends Sprite2D

@export var og_scale: Vector2 = Vector2(1, 1)
@export var bumpin_scale: Vector2 = Vector2(1.25, 1.25)
@export var bumpin_speed: float = 0.25
@export var music_div: int = 4
@export var what_music: String = "Freaky Menu"
@export var load_img: String = ""

var beat = 0
var ind = 0

var menuBG := ["menuBG", "menuBGBlue", "menuBGMagenta", "menuDesat", "menuAdam"]

func _ready():
	scale = og_scale

func reloadImage():
	if load_img != "":
		if menuBG.has(load_img):
			if FileAccess.file_exists("Assets/Images/UI/" + Setting.engine() + "/" + load_img + ".png"):
				texture = Game.load_image("Assets/Images/UI/" + Setting.engine() + "/" + load_img + ".png")
			elif FileAccess.file_exists("Assets/Images/UI/FNF/" + load_img + ".png"):
				texture = Game.load_image("Assets/Images/UI/FNF/" + load_img + ".png")
			else:
				texture = Game.load_image(Paths.missing)
		else:
			if FileAccess.file_exists(load_img):
				texture = Game.load_image(load_img)
			else:
				texture = Game.load_image(Paths.missing)

var last_engine := ""

func _process(_delta):
	if last_engine != Setting.engine():
		last_engine = Setting.engine()
		reloadImage()
		
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

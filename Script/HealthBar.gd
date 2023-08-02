extends TextureRect

var last_health := 50.0

@onready var health = $HealthBar
@onready var icon = $icons
@onready var p1 = $icons/iconP1
@onready var p2 = $icons/iconP2

var styleboxbg: StyleBoxFlat
var styleboxfill: StyleBoxFlat

var p1_win: int
var p1_normal: int
var p1_lose: int
var p2_win: int
var p2_normal: int
var p2_lose: int

func _ready():
	await Game.game_ready
	p1.texture = Paths.p_icon(Game.p1_json.healthicon)
	p2.texture = Paths.p_icon(Game.p2_json.healthicon)
	
	styleboxbg = StyleBoxFlat.new()
	styleboxfill = StyleBoxFlat.new()
	var healthcolor_p1 = Game.p1_json.healthbar_colors
	var healthcolor_p2 = Game.p2_json.healthbar_colors
	
	styleboxfill.bg_color = Color(healthcolor_p1[0] / 255.0, healthcolor_p1[1] / 255.0, healthcolor_p1[2] / 255.0) #Color8(int(healthcolor_p1[0]),int(healthcolor_p1[1]),int(healthcolor_p1[2]))
	styleboxbg.bg_color = Color(healthcolor_p2[0] / 255.0, healthcolor_p2[1] / 255.0, healthcolor_p2[2] / 255.0) #Color8(int(healthcolor_p2[0]),int(healthcolor_p2[1]),int(healthcolor_p2[2]))
	iconUpdate()
	health.set("theme_override_styles/background", styleboxbg)
	health.set("theme_override_styles/fill", styleboxfill)

func _process(_delta):
	if Game.health != last_health:
		var t = create_tween()
		t.parallel()
		t.tween_property(health, "value", Game.health_percent, 0.05)
		t.tween_property(icon, "position", Vector2(600 - Game.health * 300, 20), 0.05)
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_QUART)
		last_health = Game.health
		if Game.health_percent > 80.0:
			p1.frame = p1_win
			p2.frame = p2_lose
		elif Game.health_percent < 20.0:
			p1.frame = p1_lose
			p2.frame = p2_win
		else:
			p1.frame = p1_normal
			p2.frame = p2_normal

func hframe_check():
	if p1.texture.get_width() == 150:
		p1_win = 0
		p1_normal = 0
		p1_lose = 0
		p1.hframes = 1
	elif p1.texture.get_width() == 300:
		p1_win = 0
		p1_normal = 0
		p1_lose = 1
		p1.hframes = 2
	elif p1.texture.get_width() == 450:
		p1_win = 2
		p1_normal = 0
		p1_lose = 1
		p1.hframes = 3
	if p2.texture.get_width() == 150:
		p2_win = 0
		p2_normal = 0
		p2_lose = 0
		p2.hframes = 1
	elif p2.texture.get_width() == 300:
		p2_win = 0
		p2_normal = 0
		p2_lose = 1
		p2.hframes = 2
	elif p2.texture.get_width() == 450:
		p2_win = 2
		p2_normal = 0
		p2_lose = 1
		p2.hframes = 3

func iconUpdate():
	if Game.iconBF != "":
		var tex: Texture2D = Paths.p_icon(Game.iconBF)
		p1.texture = tex
		if styleboxfill:
			styleboxfill.bg_color = Game.getColor(tex, 70, 80)
	if Game.iconDAD != "":
		var tex: Texture2D = Paths.p_icon(Game.iconDAD)
		p2.texture = tex
		if styleboxbg:
			styleboxbg.bg_color = Game.getColor(tex, 70, 80)
	hframe_check()

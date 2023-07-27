extends TextureRect

var last_health := 50.0

@onready var health = $HealthBar
@onready var icon = $icons
@onready var p1 = $icons/iconP1
@onready var p2 = $icons/iconP2

func _ready():
	await get_tree().create_timer(0.05).timeout
	if FileAccess.file_exists("res://Assets/Images/Icons/icon-" + Game.p1_json.healthicon + ".png"):
		p1.texture = load("res://Assets/Images/Icons/icon-" + Game.p1_json.healthicon + ".png")
	elif FileAccess.file_exists("res://Assets/Images/Icons/" + Game.p1_json.healthicon + ".png"):
		p1.texture = load("res://Assets/Images/Icons/" + Game.p1_json.healthicon + ".png")
	if FileAccess.file_exists("res://Assets/Images/Icons/icon-" + Game.p2_json.healthicon + ".png"):
		p2.texture = load("res://Assets/Images/Icons/icon-" + Game.p2_json.healthicon + ".png")
	elif FileAccess.file_exists("res://Assets/Images/Icons/" + Game.p2_json.healthicon + ".png"):
		p2.texture = load("res://Assets/Images/Icons/" + Game.p2_json.healthicon + ".png")
	
	var styleboxbg = StyleBoxFlat.new()
	var styleboxfill = StyleBoxFlat.new()
	var healthcolor_p1 = Game.p1_json.healthbar_colors
	var healthcolor_p2 = Game.p2_json.healthbar_colors
	
	styleboxfill.bg_color = Color(healthcolor_p1[0] / 255.0, healthcolor_p1[1] / 255.0, healthcolor_p1[2] / 255.0) #Color8(int(healthcolor_p1[0]),int(healthcolor_p1[1]),int(healthcolor_p1[2]))
	styleboxbg.bg_color = Color(healthcolor_p2[0] / 255.0, healthcolor_p2[1] / 255.0, healthcolor_p2[2] / 255.0) #Color8(int(healthcolor_p2[0]),int(healthcolor_p2[1]),int(healthcolor_p2[2]))
	
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
			p1.frame = 0
			p2.frame = 1
		elif Game.health_percent < 20.0:
			p1.frame = 1
			p2.frame = 0
		else:
			p1.frame = 0
			p2.frame = 0

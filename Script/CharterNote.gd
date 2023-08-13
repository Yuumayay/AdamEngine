extends Node2D

@onready var chart = get_parent().get_parent()
@onready var cam = chart.get_node("Camera")
@onready var button = $Button

var hit := false
var og_y := 0.0
var last_grid := 1.0

var drag := false

const MASS_SIZE = 50

# グリッド この関数でX,Yグリッドセット
func fix_grid(x):
	return floor( x / MASS_SIZE ) * MASS_SIZE

# グリッド この関数でX,Yマス目番号変換
func get_grid(x):
	return floor( x / MASS_SIZE ) 

func _ready():
	og_y = position.y

func _process(_delta):
	if last_grid != chart.grid:
		last_grid = chart.grid
		button.size.y = 50 * last_grid
		print(50 * last_grid)
	if cam.position.y - 360 > position.y - 300:
		if chart.playing and not hit: Audio.a_play("osu")
		if not hit: hit = true
	else:
		hit = false
	if hit:
		modulate.a = 0.5
	else:
		modulate.a = 1
	#if drag:
		#position.x = fix_grid(get_global_mouse_position().x)
		#position.y = fix_grid(get_global_mouse_position().y)
	#else:
		#position.y = og_y



func _on_button_button_down():
	#drag = true
	Audio.a_play("Erase")
	queue_free()

func _on_button_button_up():
	pass
	#drag = false

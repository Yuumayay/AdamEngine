extends Node2D

@onready var chart = get_parent().get_parent()
@onready var cam = chart.get_node("Camera")
@onready var button = $Button
@onready var line :Line2D = $line

var hit := false
var og_y := 0.0
var last_grid := 1.0
var uid :int = -1
var drag := false
var mouse_enter := false
var vSpeed := 0.0

const MASS_SIZE = 50

# グリッド この関数でX,Yグリッドセット
func fix_grid(x):
	return floor( x / MASS_SIZE ) * MASS_SIZE

# グリッド この関数でX,Yマス目番号変換
func get_grid(x):
	return floor( x / MASS_SIZE ) 
func _ready():
	og_y = position.y
	uid = get_instance_id()
	name = str(uid)

func _process(delta):
	if last_grid != chart.grid:
		last_grid = chart.grid
		button.size.y = 50 * last_grid
		print(50 * last_grid)
	if cam.position.y - 360 > position.y - 260:
		if chart.playing and not hit: Audio.a_play("osu")
		if not hit: hit = true
	else:
		hit = false
	if mouse_enter:
		if modulate.v <= 1.5:
			vSpeed += 0.5 * delta 
		else:
			vSpeed -= 0.5 * delta
		modulate.v += vSpeed
	elif hit:
		modulate.v = 1
		modulate.a = 0.5
	else:
		modulate.v = 1
		modulate.a = 1

		
	#if drag:
		#position.x = fix_grid(get_global_mouse_position().x)
		#position.y = fix_grid(get_global_mouse_position().y)
	#else:
		#position.y = og_y


func _on_button_button_down():
	#drag = true
	Audio.a_play("Erase")
	
	chart.deleteNote(uid)
	
	queue_free()

func _on_button_button_up():
	pass
	#drag = false


func _on_button_mouse_entered():
	mouse_enter = true
	chart._on_button_mouse_entered()
	

func _on_button_mouse_exited():
	mouse_enter = false
	chart._on_button_mouse_exited()

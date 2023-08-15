extends TextureRect

var type := 0
enum {EVENT, BF, DAD, GF}
var gfSection := false

var section := 0
@onready var chart = $/root/"Chart Editor"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if type == GF:
		if chart.chartData.notes[chart.cur_section].has("gfSection"):
			if chart.chartData.notes[chart.cur_section]["gfSection"]:
				gfSection = true
				modulate.v = lerp(modulate.v, 1.25, 0.1)
			else:
				gfSection = false
				modulate.v = lerp(modulate.v, 1.0, 0.1)
	if type != GF and gfSection:
		modulate.v = lerp(modulate.v, 1.0, 0.1)
		return
	if type == BF and not gfSection:
		if chart.chartData.notes[chart.cur_section]["mustHitSection"]:
			modulate.v = lerp(modulate.v, 1.25, 0.1)
		else:
			modulate.v = lerp(modulate.v, 1.0, 0.1)
	elif type == DAD and not gfSection:
		if not chart.chartData.notes[chart.cur_section]["mustHitSection"]:
			modulate.v = lerp(modulate.v, 1.25, 0.1)
		else:
			modulate.v = lerp(modulate.v, 1.0, 0.1)
			
func _on_button_button_down():
	chart.on_mouse_down_set_note(self)
	


func _on_button_mouse_entered():
	chart._on_button_mouse_entered()


func _on_button_mouse_exited():
	chart._on_button_mouse_exited()

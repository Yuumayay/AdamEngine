extends TextureRect

var type := 0
var index := 0
@onready var chart = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	chart.on_mouse_down_set_note(self)
	

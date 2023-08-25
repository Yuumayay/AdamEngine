extends Sprite2D

var frame_ind := 0
var frame_array: Array

func _ready():
	$Button.pressed.connect(pressed)

func pressed():
	frame_ind += 1
	if frame_ind >= frame_array.size():
		frame_ind = 0
	frame = frame_array[frame_ind]
	get_parent().get_parent().call(name + "_pressed")

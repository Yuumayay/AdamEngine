extends Line2D

@export var ind: int = 0

func _process(delta):
	position.y = ind * 200 + Chart.cur_y

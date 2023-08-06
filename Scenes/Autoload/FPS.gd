extends CanvasLayer

@onready var label: Label = $Label
#var fps := 0

func _process(delta):
	var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 104857.6
	label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nMemory: " + str(round(mem) / 10) + " MB"
	#fps = floor(1.0 / delta)
	
#Engine.get_frames_per_second()

#func _physics_process(delta):
#	fps = floor(1.0 / delta)

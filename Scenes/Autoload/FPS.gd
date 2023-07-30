extends CanvasLayer

@onready var label: Label = $Label

func _process(_delta):
	var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 104857.6
	label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nMemory: " + str(round(mem) / 10) + " MB"
	
#Engine.get_frames_per_second()

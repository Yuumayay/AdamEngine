extends CanvasLayer

@onready var label: Label = $Label

var count := 0
func _process(delta):
	if count > 20:
		var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 104857.6
		label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nMemory: " + str(round(mem) / 10) + " MB"
		count = 0
	count += 1
	

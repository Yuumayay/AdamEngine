extends Node2D


func _ready():
	for i in range(80):
		Audio.a_volume_set("Debug Menu", -i)
		await get_tree().create_timer(0.001).timeout

extends Node2D

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Trans.t_trans("Main Menu")

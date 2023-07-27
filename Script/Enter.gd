extends RichTextLabel

func accepted():
	Game.can_input = false
	print("accepted")
	for i in range(10):
		modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.05).timeout
		modulate = Color(0, 1, 1)
		await get_tree().create_timer(0.05).timeout
	Trans.t_trans("Main Menu")

extends Node2D

@export var ind: int
@export var color: Color
#@export var same_name_ind: int
@export var storyName: String
var weekName: String

func accepted(selected: bool):
	if selected:
		for i in range(10):
			modulate = Color(1, 1, 1, 0)
			await get_tree().create_timer(0.05).timeout
			modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.05).timeout
		Trans.t_trans("Gameplay")
	else:
		var t = get_tree().create_tween()
		t.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.25)
		t.set_trans(Tween.TRANS_QUINT)
		t.set_ease(Tween.EASE_IN)

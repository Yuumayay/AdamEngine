extends Node2D

func _ready():
	if get_child_count() == 0:
		var spr = Game.load_XMLSprite("res://Assets/Images/Main Menu/FNF_main_menu_assets.xml", "", true, 24)
		spr.name = "Sprite"
		add_child(spr)
	else:
		$Sprite.play(name.to_lower() + " basic")

func accepted(selected: bool):
	var t = get_tree().create_tween()
	if selected:
		t.tween_property(self, "scale", Vector2(1, 1), 0.25)
		for i in range(10):
			modulate = Color(1, 1, 1, 0)
			await get_tree().create_timer(0.05).timeout
			modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.05).timeout
		Trans.t_trans(name)
	else:
		t.tween_property(self, "position", Vector2(position.x - 100, position.y), 0.25)
		t.tween_property(self, "position", Vector2(2000, position.y), 0.25)
		t.set_trans(Tween.TRANS_QUINT)
		t.set_ease(Tween.EASE_IN)

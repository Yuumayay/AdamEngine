extends RichTextLabel

@export var ind: int
@export var color: Color
var week: String

func accepted(selected: bool):
	var t = get_tree().create_tween()
	if selected:
		t.tween_property(self, "scale", Vector2(5, 5), 0.1)
		for i in range(10):
			modulate = Color(1, 1, 1, 0)
			await get_tree().create_timer(0.05).timeout
			modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.05).timeout
		if Game.debug_mode:
			Trans.t_trans("Editors/" + name)
			Game.debug_mode = false
		else:
			var song_data = File.f_read(Paths.p_chart(Game.cur_song, Game.cur_diff), ".json")
			if song_data.song.has("is3D"):
				if song_data.song.is3D:
					Game.is3D = true
					Trans.t_trans("Gameplay3D")
				else:
					Game.is3D = false
					Trans.t_trans("Gameplay")
			else:
				Game.is3D = false
				Trans.t_trans("Gameplay")
	else:
		t.tween_property(self, "position", Vector2(position.x + 100, position.y), 0.25)
		t.tween_property(self, "position", Vector2(-2000, position.y), 0.25)
		t.set_trans(Tween.TRANS_QUINT)
		t.set_ease(Tween.EASE_IN)

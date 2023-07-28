extends CanvasLayer

func _process(delta):
	if $Sprite.modulate.a >= 0.0:
		$Sprite.modulate.a -= delta * (Audio.bpm / 30.0)

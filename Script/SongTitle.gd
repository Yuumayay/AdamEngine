extends CanvasLayer

func _ready():
	await Game.song_start
	if Game.song_data.song.has("songTitle"):
		if not Game.song_data.song.songTitle:
			return
	if FileAccess.file_exists("Mods/images/songtitle/" + Game.cur_song.to_lower() + ".png"):
		var title = Game.load_image("Mods/images/songtitle/" + Game.cur_song.to_lower() + ".png")
		var spr = TextureRect.new()
		spr.texture = title
		spr.position.x = 1280
		
		add_child(spr)
		
		var t : Tween
		t = create_tween()
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_QUART)
		t.tween_property(spr, "position:x", 0, 0.5)
		t.tween_interval(2)
		t.tween_property(spr, "position:x", -1280, 0.5)
		t.tween_callback(func(): queue_free())
		t.play()

func spawnTitle(sec):
	var title = Game.load_image("Mods/images/songtitle/" + Game.cur_song.to_lower() + ".png")
	var spr = TextureRect.new()
	spr.texture = title
	spr.position.x = 1280
	
	add_child(spr)
	
	var t : Tween
	t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUART)
	t.tween_property(spr, "position:x", 0, 0.5)
	t.tween_interval(sec)
	t.tween_property(spr, "position:x", -1280, 0.5)
	t.tween_callback(func(): queue_free())
	t.play()

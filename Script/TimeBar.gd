extends ProgressBar

var atime = 1.0

func _ready():
	if not Setting.s_get("gameplay", "downscroll"):
		get_parent().position.y = 700 - get_parent().position.y
	value = 0.0

func updatePos():
	if not Setting.s_get("gameplay", "downscroll"):
		get_parent().position.y = 700 - get_parent().position.y
	else:
		get_parent().position.y = 678

func _process(delta):
	atime += delta * Game.cur_multi
	
	if Game.cur_state == Game.PLAYING:
		value = Audio.cur_ms
		max_value = Audio.songLength
	
		if atime > 1.0:
			var remain_sec = int(floor((Audio.songLength - Audio.cur_ms) / 1000.0))
			var remain_min = int(floor(remain_sec / 60.0))
			atime -= 1.0
			if Game.PLAYING and !$Label.visible:
				$Label.visible = true
			$Label.text = "%d:%02d" % [remain_min, remain_sec % 60]
			if Setting.s_get("gameplay", "botplay"):
				$Label.text += " (BOT)"
			if Setting.s_get("gameplay", "practice"):
				$Label.text += " (PRACTICE)"

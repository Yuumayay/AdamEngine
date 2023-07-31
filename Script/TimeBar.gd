extends ProgressBar

var atime = 1.0

func _ready():
	value = 0.0

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

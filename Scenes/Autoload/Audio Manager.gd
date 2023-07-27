extends Node

signal beat_hit

var bpm: float
var cur_ms: float
var cur_beat: int
var cur_beat_float: float
var cur_sec: float
var cur_section: int

func a_play(key: String, pitch = 1.0, volume = 0.0, position = 0.0):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.pitch_scale = pitch
		target.volume_db = volume
		target.play()
		target.seek(position)
	else:
		printerr("audio_play: node not found")

func a_stop(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.playing = false
	else:
		printerr("audio_stop: node not found")

func a_pause(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.stream_paused = true
	else:
		printerr("audio_stop: node not found")

func a_resume(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.stream_paused = false
	else:
		printerr("audio_stop: node not found")

func a_check(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		if target.playing:
			return true
		return false
	else:
		printerr("audio_check: node not found")

func a_set(key: String, path: String):
	var target: AudioStreamPlayer = get_node(key)
	if path == "":
		target.stream = null
	else:
		if FileAccess.file_exists(path):
			var soundfile: AudioStreamOggVorbis = load(path)
			target.stream = soundfile
		else:
			printerr("audio_set: sound not found")

func a_volume_set(key: String, volume: float):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.volume_db = volume
	else:
		printerr("audio_volume_set: node not found")

func a_title():
	get_node("Freaky Menu").play()
	
func a_accept():
	get_node("Accept").play()

func a_cancel():
	get_node("Cancel").play()

func a_scroll():
	get_node("Scroll").play()

func a_get_beat(key: String, BPM: float, beat = 1):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		#var bars = target.stream.bar_beats
		var bpm2 = BPM
		return floor(a_get_sec(key) * bpm2 / 60.0 * beat)
	else:
		printerr("audio_get_beat: node not found")
		
func a_get_beat_float(key: String, BPM: float, beat = 1):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		#var bars = target.stream.bar_beats
		var bpm2 = BPM
		return a_get_sec(key) * bpm2 / 60.0 * beat
	else:
		printerr("audio_get_beat_float: node not found")

func a_get_sec(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		var time = target.get_playback_position() + AudioServer.get_time_since_last_mix()
		time -= AudioServer.get_output_latency()
		return time
	else:
		printerr("audio_get_sec: node not found")

var value = 0

func _process(_delta):
	if a_check("Inst"):
		if Game.cur_state != Game.PAUSE:
			cur_beat = a_get_beat("Inst", bpm)
			cur_beat_float = a_get_beat_float("Inst", bpm)
			cur_sec = a_get_sec("Inst")
			cur_section = a_get_beat("Inst", bpm) * 4 / 16
			cur_ms = cur_beat_float * (60.0 / bpm * 1000)
			#print(cur_ms)
			if value != a_get_beat("Inst", bpm, 1):
				emit_signal("beat_hit")
				value = a_get_beat("Inst", bpm, 1)
			if Game.who_sing_section[cur_section]:
				Game.mustHit = true
			else:
				Game.mustHit = false

extends Node



############################## シグナル ##############################

signal beat_hit



############################## 変数 ##############################

var bpm: float
var cur_ms: float
var cur_beat: int
var cur_beat_float: float
var cur_sec: float
var cur_section: int
var songLength: float
var beatLength: float

var beat_hit_bool: bool = false
var beat_hit_event: bool = false
var section_hit_event: bool = false

var bpm_array: Array = [100, 200, 400]



############################## 関数 ##############################

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

func a_get_length(key: String):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		return target.stream.get_length() * 1000.0
	else:
		printerr("audio_check: node not found")

func a_set(key: String, path: String, BPM : float = 100, loop = false, bars = 4):
	var target: AudioStreamPlayer = get_node(key)
	if path == "":
		target.stream = null
	else:
		if FileAccess.file_exists(path):
			var soundfile: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(path) #load(path)
			soundfile.bpm = BPM
			soundfile.loop = loop
			soundfile.bar_beats = bars
			target.stream = soundfile
		else:
			printerr("audio_set: sound not found")

func a_volume_set(key: String, volume: float):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.volume_db = volume
	else:
		printerr("audio_volume_set: node not found")

func a_volume_add(key: String, volume: float):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		target.volume_db += volume
	else:
		printerr("audio_volume_set: node not found")

func se_set(key: String, path: String):
	var target: AudioStreamPlayer = get_node(key)
	if path == "":
		target.stream = null
	else:
		if FileAccess.file_exists(path):
			var soundfile: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(path) #load(path)
			soundfile.loop = false
			target.stream = soundfile
			print("se_set: load @ "+ path)
		else:
			printerr("se_set: sound not found @ "+ path)

func a_title():
	get_node("Freaky Menu").play()
	
func a_accept():
	get_node("Accept").play()

func a_cancel():
	get_node("Cancel").play()

func a_scroll():
	get_node("Scroll").play()

func a_get_beat(key: String, beat = 4):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		var bars = target.stream.bar_beats
		var BPM = target.stream.bpm
		var speed = target.pitch_scale
		return floor(a_get_sec(key) * BPM / 60.0 / bars * beat / speed)
	else:
		printerr("audio_get_beat: node not found")
		
func a_get_beat_float(key: String, beat = 4):
	var target: AudioStreamPlayer = get_node_or_null(key)
	if target:
		var bars = target.stream.bar_beats
		var BPM = target.stream.bpm
		return a_get_sec(key) * BPM / 60.0 / bars * beat
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



############################## オーディオの読み込みと初期化 ##############################

func _ready():
	# music
	var system_music = File.f_read(Paths.p_offset("Music/Offset.json"), ".json").system_music
	for m in system_music:
		Audio.a_set(m[0], "Assets/Music/" + m[1], float(m[2]), m[3])
	
	# sound
	var system_sound = File.f_read(Paths.p_offset("Sound/Offset.json"), ".json").system_sound
	for m in system_sound:
		Audio.se_set(m[0], "Assets/Sounds/FNF/" + m[1])


############################## 曲の情報更新 ##############################

var value := 0
var value2 := 0

func _process(_delta):
	if a_check("Inst"):
		if beatLength == 0:
			beatLength = 60.0 / bpm
		if songLength == 0:
			songLength = a_get_length("Inst")
		if Game.cur_state != Game.PAUSE and Game.cur_state != Game.NOT_PLAYING:
			beat_hit_bool = false
			beat_hit_event = false
			section_hit_event = false
			cur_beat = a_get_beat("Inst")
			cur_beat_float = a_get_beat_float("Inst")
			cur_sec = a_get_sec("Inst")
			cur_section = a_get_beat("Inst", 1)
			cur_ms = cur_beat_float * (60.0 / bpm * 1000)
			#print(cur_ms)
			if value != a_get_beat("Inst"):
				emit_signal("beat_hit")
				value = a_get_beat("Inst")
				beat_hit_event = true
				if bpm < bpm_array[0]:
					beat_hit_bool = true
				elif bpm < bpm_array[1]:
					beat_hit_bool = true
				elif bpm < bpm_array[2]:
					if value % 2 == 0:
						beat_hit_bool = true
				else:
					if value % 4 == 0:
						beat_hit_bool = true
			if value2 != a_get_beat("Inst", 1):
				value2 = a_get_beat("Inst", 1)
				section_hit_event = true
			if cur_section <= Game.who_sing_section.size() - 1:
				if Game.who_sing_section[cur_section]:
					Game.mustHit = true
				else:
					Game.mustHit = false
			else:
				Game.mustHit = false

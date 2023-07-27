extends Node2D

@onready var template_rect: ColorRect = get_parent().get_node("Rect")
@onready var container: TabContainer = get_parent().get_node("Container")
@onready var beat: Line2D = get_parent().get_node("Beat")

func _ready():
	if FileAccess.file_exists(Paths.p_song(Game.cur_song.to_lower() + "/Voices")):
		Audio.a_set("Voices", Paths.p_song(Chart.cur_song.to_lower() + "/Voices"))
	Audio.a_set("Inst", Paths.p_song(Chart.cur_song.to_lower() + "/Inst"))
	
	draw_mass_and_line()
	for i in range(80):
		Audio.a_volume_set("Debug Menu", -i)
		await get_tree().create_timer(0.001).timeout

func draw_mass_and_line():
	draw_mass(50, 250, 1, 32, 1, 0, Chart.cur_section, 0)
	draw_mass(150, 250, Game.key_count, 32, 1, 1, Chart.cur_section, 1)
	draw_mass(200 + (50 * Game.key_count), 250, Game.key_count, 32, 1, 2, Chart.cur_section, 2)
	draw_beat_line(8, Chart.cur_section * 4)

func draw_mass(og_x, og_y, column, row, alpha, type, section, player):
	var index = 0
	var x = og_x
	var y = og_y
	for i in column:
		index += 1
		y = og_y
		x += 50
		for ind in row:
			y += 50
			var new_rect = template_rect.duplicate()
			new_rect.position = Vector2(x, y)
			if index % 2 == 0:
				new_rect.color = Color(0.45, 0.45, 0.45)
			else:
				new_rect.color = Color(0.55, 0.55, 0.55)
			new_rect.visible = true
			if ind >= 16:
				new_rect.modulate.a = 0.5
			new_rect.type = type
			new_rect.dir = i
			new_rect.ms = ind + (Chart.cur_section * 16)
			new_rect.player = player
			add_child(new_rect)
			index += 1

func draw_beat_line(value, value2):
	for i in value:
		var new_beat = beat.duplicate()
		new_beat.visible = true
		new_beat.ind = i + value2
		new_beat.get_node("Label").text = str(i + value2)
		add_child(new_beat)

func _process(delta):
	#print(Chart.cur_y)
	setting_check()
	key_check()
	scroll()

var ind: int = 0

func scroll():
	if Chart.playing:
		Chart.cur_y = Audio.a_get_beat_float("Inst", Chart.bpm) * -200 * Chart.multi
		if ind != Audio.a_get_beat("Inst", Chart.metronome_bpm):
			ind = Audio.a_get_beat("Inst", Chart.metronome_bpm)
			if Chart.metronome:
				if ind % 4 == 0:
					Audio.a_play("Tick")
				else:
					Audio.a_play("Tock")
	if Input.is_action_just_pressed("game_scroll_up"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y += 50 * Chart.mouse_scroll_speed * 4
		else:
			Chart.cur_y += 50 * Chart.mouse_scroll_speed
	if Input.is_action_just_pressed("game_scroll_down"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y -= 50 * Chart.mouse_scroll_speed * 4
		else:
			Chart.cur_y -= 50 * Chart.mouse_scroll_speed
	if Chart.cur_y > 0 + (-800 * Chart.cur_section):
		if Chart.cur_section != 0:
			for i in get_children():
				remove_child(i)
			Chart.cur_section -= 1
			draw_mass_and_line()
	if Chart.cur_y < -800 + (-800 * Chart.cur_section):
		for i in get_children():
			remove_child(i)
		Chart.cur_section += 1
		draw_mass_and_line()

func setting_check():
	if container.get_node("Charting/Flow/Metronome/Margin/Flow/CheckBox").button_pressed:
		Chart.metronome = true
	else:
		Chart.metronome = false
	
	Chart.metronome_bpm = container.get_node("Charting/Flow/BPM/Margin/Flow/SpinBox").value
	Chart.multi = container.get_node("Charting/Flow/Playback Rate/Margin/Flow/SpinBox").value
	Chart.mouse_scroll_speed = container.get_node("Charting/Flow/Mouse Scroll Speed/Margin/Flow/SpinBox").value

func key_check():
	if Input.is_action_just_pressed("game_space"):
		if Chart.playing:
			stop_audio()
		else:
			print(Chart.position_to_time())
			Chart.playing = true
			Audio.a_play("Inst", Chart.multi, 0.0, Chart.position_to_time())
			Audio.a_play("Voices", Chart.multi, 0.0, Chart.position_to_time())
	if Input.is_action_just_pressed("game_editor_prev"): 
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y += 800 * 4
		else:
			Chart.cur_y += 800
	if Input.is_action_just_pressed("game_editor_next"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y -= 800 * 4
		else:
			Chart.cur_y -= 800

func stop_audio():
	Chart.playing = false
	Audio.a_stop("Inst")
	Audio.a_stop("Voices")

extends Node2D

@onready var template_rect: ColorRect = get_parent().get_node("Rect")
#@onready var container: TabContainer = get_parent().get_node("Container")
@onready var beat: Line2D = get_parent().get_node("Beat")
@onready var cam = get_parent().get_node("Camera")

func _ready():
	if FileAccess.file_exists(Paths.p_song(Game.cur_song.to_lower(), "Voices")):
		Audio.a_set("Voices", Paths.p_song(Chart.cur_song.to_lower(), "Voices"))
	Audio.a_set("Inst", Paths.p_song(Chart.cur_song.to_lower(), "Inst"))
	
	draw_all()
	for i in range(80):
		Audio.a_volume_set("Debug Menu", -i)
		await get_tree().create_timer(0.001).timeout

func draw_all():
	var total_x := 0
	var space := 50
	var bf_pos: Array = []
	var dad_pos: Array = []
	var gf_pos: Array = []
	var bf_key = Chart.bf_data["key_count"]
	var dad_key = Chart.dad_data["key_count"]
	var gf_key = Chart.gf_data["key_count"]
	
	# remove all child
	for i in get_children():
		remove_child(i)
	
	# event mass
	draw_mass(50, 250, 1, 32, 1, 0, Chart.cur_section, 0, 0)
	total_x += 50 + space
	
	# bf mass
	for i in Chart.bf_count:
		total_x += space
		bf_pos.append(total_x)
		draw_mass(total_x, 250, bf_key[i], 32, 1, 0, Chart.cur_section, 1, i)
		total_x += (50 * bf_key[i])
	
	# dad mass
	for i in Chart.dad_count:
		total_x += space
		dad_pos.append(total_x)
		draw_mass(total_x, 250, dad_key[i], 32, 1, 0, Chart.cur_section, 2, i)
		total_x += (50 * dad_key[i])
	
	# gf mass
	for i in Chart.gf_count:
		total_x += space
		gf_pos.append(total_x)
		draw_mass(total_x, 250, gf_key[i], 32, 1, 0, Chart.cur_section, 3, i)
		total_x += (50 * gf_key[i])
	
	# beat line
	draw_beat_line(8, Chart.cur_section * 4)
	
	# event icon
	draw_icon(75, "botfriend", "EVENT", null)
	
	# bf icon
	for i in Chart.bf_count:
		draw_icon(bf_pos[i] + (50.0 * bf_key[i] / 2.0), Chart.bf_data["icon_name"][i], "PLAYER", i)
	
	# dad icon
	for i in Chart.dad_count:
		draw_icon(dad_pos[i] + (50.0 * dad_key[i] / 2.0), Chart.dad_data["icon_name"][i], "OPPONENT", i)
	
	# gf icon
	for i in Chart.gf_count:
		draw_icon(gf_pos[i] + (50.0 * gf_key[i] / 2.0), Chart.gf_data["icon_name"][i], "GF", i)

func draw_mass(og_x, og_y, column, row, alpha, type, section, player, p_ind):
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
				new_rect.color = Color(0.5, 0.5, 0.5)
			else:
				new_rect.color = Color(0.55, 0.55, 0.55)
			new_rect.visible = true
			if ind >= 16:
				new_rect.modulate.a = 0.5
			new_rect.note_type = type
			new_rect.dir = i
			new_rect.ms = ind + (Chart.cur_section * 16)
			new_rect.player_type = player
			new_rect.player_ind = p_ind
			add_child(new_rect)
			index += 1

func draw_beat_line(value, value2):
	for i in value:
		var new_beat = beat.duplicate()
		new_beat.visible = true
		new_beat.ind = i + value2
		new_beat.get_node("Label").text = str(i + value2)
		add_child(new_beat)

func draw_icon(x, icon_name, p_type, p_ind):
	var new_icon = Sprite2D.new()
	new_icon.texture = Paths.p_icon(icon_name)
	new_icon.position.x = x + 50
	new_icon.position.y = 50
	new_icon.hframes = floor(new_icon.texture.get_width() / 150.0)
	new_icon.scale = Vector2(0.5, 0.5)
	
	new_icon.set_script(load("res://Script/CharterIcon.gd"))
	new_icon.icon_name = icon_name
	new_icon.p_type = p_type
	if p_ind is int:
		new_icon.p_ind = p_ind
	if p_type == "PLAYER":
		new_icon.key_count = Chart.bf_data["key_count"][p_ind]
	elif p_type == "OPPONENT":
		new_icon.key_count = Chart.dad_data["key_count"][p_ind]
	elif p_type == "GF":
		new_icon.key_count = Chart.gf_data["key_count"][p_ind]
	new_icon.init()
	
	add_child.call_deferred(new_icon)

func add_character(type):
	if type == "PLAYER":
		Chart.bf_count += 1
		Chart.bf_data["key_count"].append(4)
		Chart.bf_data["icon_name"].append("bf")
		draw_all()
	elif type == "OPPONENT":
		Chart.dad_count += 1
		Chart.dad_data["key_count"].append(4)
		Chart.dad_data["icon_name"].append("dad")
		draw_all()
	elif type == "GF":
		Chart.gf_count += 1
		Chart.gf_data["key_count"].append(4)
		Chart.gf_data["icon_name"].append("gf")
		draw_all()

func erase_character(type, ind):
	if type == "PLAYER":
		Chart.bf_count -= 1
		Chart.bf_data["key_count"].erase(Chart.bf_data["key_count"][ind])
		Chart.bf_data["icon_name"].erase(Chart.bf_data["icon_name"][ind])
		draw_all()
	elif type == "OPPONENT":
		Chart.dad_count -= 1
		Chart.dad_data["key_count"].erase(Chart.dad_data["key_count"][ind])
		Chart.dad_data["icon_name"].erase(Chart.dad_data["icon_name"][ind])
		draw_all()
	elif type == "GF":
		Chart.gf_count -= 1
		Chart.gf_data["key_count"].erase(Chart.gf_data["key_count"][ind])
		Chart.gf_data["icon_name"].erase(Chart.gf_data["icon_name"][ind])
		draw_all()

func clone_character(type, icon_name, key_count):
	if type == "PLAYER":
		Chart.bf_count += 1
		Chart.bf_data["key_count"].append(key_count)
		Chart.bf_data["icon_name"].append(icon_name)
		draw_all()
	elif type == "OPPONENT":
		Chart.dad_count += 1
		Chart.dad_data["key_count"].append(key_count)
		Chart.dad_data["icon_name"].append(icon_name)
		draw_all()
	elif type == "GF":
		Chart.gf_count += 1
		Chart.gf_data["key_count"].append(key_count)
		Chart.gf_data["icon_name"].append(icon_name)
		draw_all()

func set_character(type, ind, value):
	if type == "PLAYER":
		Chart.bf_data["icon_name"][ind] = value
		draw_all()
	elif type == "OPPONENT":
		Chart.dad_data["icon_name"][ind] = value
		draw_all()
	elif type == "GF":
		Chart.gf_data["icon_name"][ind] = value
		draw_all()

func set_key_count(type, ind, value):
	if type == "PLAYER":
		if Chart.bf_data["key_count"][ind] > value:
			var index := 0
			for i in Chart.placed_notes.notes:
				print(i)
				if i[0] >= value:
					Chart.placed_notes.notes.erase(Chart.placed_notes.notes[index])
				index += 1
		Chart.bf_data["key_count"][ind] = value
		draw_all()
	elif type == "OPPONENT":
		if Chart.dad_data["key_count"][ind] > value:
			var index := 0
			for i in Chart.placed_notes.notes:
				if i[0] >= value:
					Chart.placed_notes.notes.erase(Chart.placed_notes.notes[index])
				index += 1
		Chart.dad_data["key_count"][ind] = value
		draw_all()
	elif type == "GF":
		if Chart.gf_data["key_count"][ind] > value:
			var index := 0
			for i in Chart.placed_notes.notes:
				if i[0] >= value:
					Chart.placed_notes.notes[index].erase()
				index += 1
		Chart.gf_data["key_count"][ind] = value
		draw_all()

func set_note_skin(type, ind, value):
	pass

func _process(_delta):
	cam.position.x = 640 + Chart.cur_x
	cam.zoom = Vector2(Chart.cur_zoom, Chart.cur_zoom)
	#print(Chart.cur_y)
	#setting_check()
	key_check()
	scroll()

var ind2: int = 0

func scroll():
	if Chart.playing:
		Chart.cur_y = Audio.a_get_beat_float("Inst", Chart.bpm) * -200 * Chart.multi
		if ind2 != Audio.a_get_beat("Inst", Chart.metronome_bpm):
			ind2 = Audio.a_get_beat("Inst", Chart.metronome_bpm)
			if Chart.metronome:
				if ind2 % 4 == 0:
					Audio.a_play("Tick")
				else:
					Audio.a_play("Tock")
	if Input.is_action_just_pressed("game_scroll_up"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y += 50 * Chart.mouse_scroll_speed * 4
		elif Input.is_action_pressed("game_ctrl"):
			Chart.cur_x += 50 * Chart.mouse_scroll_speed
		elif Input.is_action_pressed("game_alt"):
			Chart.cur_zoom += 0.05
		else:
			Chart.cur_y += 50 * Chart.mouse_scroll_speed
	if Input.is_action_just_pressed("game_scroll_down"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			Chart.cur_y -= 50 * Chart.mouse_scroll_speed * 4
		elif Input.is_action_pressed("game_ctrl"):
			Chart.cur_x -= 50 * Chart.mouse_scroll_speed
		elif Input.is_action_pressed("game_alt"):
			Chart.cur_zoom -= 0.05
		else:
			Chart.cur_y -= 50 * Chart.mouse_scroll_speed
	if Chart.cur_y > 0 + (-800 * Chart.cur_section):
		if Chart.cur_section != 0:
			Chart.cur_section -= 1
			draw_all()
	if Chart.cur_y < -800 + (-800 * Chart.cur_section):
		Chart.cur_section += 1
		draw_all()

#func setting_check():
	#if container.get_node("Charting/Flow/Metronome/Margin/Flow/CheckBox").button_pressed:
	#	Chart.metronome = true
	#else:
	#	Chart.metronome = false
	
	#Chart.metronome_bpm = container.get_node("Charting/Flow/BPM/Margin/Flow/SpinBox").value
	#Chart.multi = container.get_node("Charting/Flow/Playback Rate/Margin/Flow/SpinBox").value
	#Chart.mouse_scroll_speed = container.get_node("Charting/Flow/Mouse Scroll Speed/Margin/Flow/SpinBox").value

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

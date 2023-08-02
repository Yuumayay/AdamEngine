extends Node2D

@onready var list = get_node("Selectable")
@onready var template = get_node("Template")
@onready var template2 = get_node("Template2")

var select: int = 0
var child_count: int = 0
var select2: int = 0
var child_count2: int = 0
var layer: int = 0
var selecting: String
var select3: int = 0
var child_count3: int = 0

func _ready():
	category()
	Audio.a_stop("Freaky Menu")
	Audio.a_play("Option Menu")

func category():
	for i in list.get_children():
		list.remove_child(i)
	var ind := 0
	var json = Setting.setting.category
	for i in json:
		var new_item = template.duplicate()
		var itemname = i
		
		new_item.name = str(ind)
		new_item.text = itemname
		new_item.ind = ind
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count = list.get_child_count() - 1

func option():
	var ind := 0
	var selected_name = list.get_child(select).text.to_lower()
	var json = Setting.setting.category[selected_name]
	for i in list.get_children():
		list.remove_child(i)
	for i in json:
		var new_item = template2.duplicate()
		var valuetext = new_item.get_node("Current")
		var itemname = i
		var current = Setting.setting.category[selected_name][i]["cur"]
		var itemtype = Setting.setting.category[selected_name][i]["type"]
		
		new_item.name = str(ind)
		new_item.text = itemname
		
		match itemtype:
			"bind":
				new_item.text = "bind"
				var keytext = new_item.get_node("Current").duplicate()
				var key = Setting.setting.category[selected_name][i]["key"]
				for index in range(key):
					var note = $Note.duplicate()
					var k = new_item.get_node("Current").duplicate()
					k.position = Vector2(150, 100 * index + 150)
					for indexi in current[index]:
						k.text += indexi 
					note.position = Vector2(-100, 0)
					note.animation = View.keys[str(key) + "k"][index]
					note.scale = Vector2(0.4, 0.4)
					k.add_child(note)
					new_item.add_child(k)
				keytext.text = str(key) + "k"
				keytext.position = Vector2(190, 10)
				keytext.scale = Vector2(0.8, 0.8)
				new_item.value = key
				new_item.add_child(keytext)
			"array":
				valuetext.text = Setting.setting.category[selected_name][i]["array"][current]
			_:
				valuetext.text = str(current)
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count2 = list.get_child_count() - 1

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if layer == 0:
				if select == 0:
					select = child_count
				else:
					select -= 1
			else:
				if select2 == 0:
					select2 = child_count2
				else:
					select2 -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if layer == 0:
				if select == child_count:
					select = 0
				else:
					select += 1
			else:
				if select2 == child_count2:
					select2 = 0
				else:
					select2 += 1
		if Input.is_action_just_pressed("game_ui_left"):
			Audio.a_scroll()
			if selecting == "keybind":
				if select2 == 0:
					select2 = child_count2
				else:
					select2 -= 1
			else:
				if layer == 1:
					change_value(-1)
		if Input.is_action_just_pressed("game_ui_right"):
			Audio.a_scroll()
			if selecting == "keybind":
				if layer == 1:
					if select2 == child_count2:
						select2 = 0
					else:
						select2 += 1
			else:
				if layer == 1:
					change_value(1)
		if Input.is_action_just_pressed("ui_accept"):
			Audio.a_scroll()
			if selecting == "keybind":
				if layer >= 2:
					layer += 1
				else:
					Game.can_input = false
			else:
				if layer == 0:
					selecting = list.get_child(select).text.to_lower()
					option()
					layer += 1
				else:
					change_value(1)
		if Input.is_action_just_pressed("ui_cancel"):
			if layer == 0:
				File.f_save("user://ae_options_data", ".json", Setting.setting)
				Audio.a_stop("Option Menu")
				Audio.a_title()
				Audio.a_cancel()
				Trans.t_trans("Main Menu")
			elif layer == 1:
				selecting = ""
				category()
				layer -= 1
				select2 = 0
			else:
				layer -= 1
	update_position()

func _unhandled_key_input(event):
	if not Game.can_input and selecting == "keybind":
		Setting.setting.category[selecting].get(select2)["cur"][select3] = event.as_text()
		print(Setting.setting.category[selecting][select2]["cur"])

func update_position():
	for i in list.get_children():
		if layer == 0:
			i.position.x = 440
			i.position.y = lerp(i.position.y, -select * 150.0 + (350.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - int(String(i.name))) / 5.0, 0.25)
		elif layer == 1:
			if i.text == "bind":
				i.position.x = lerp(i.position.x, -select2 * 400 + (500.0 + int(String(i.name)) * 400), 0.25)
				i.position.y = 100
			else:
				i.position.x = 240
				i.position.y = lerp(i.position.y, -select2 * 150.0 + (350.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select2 - int(String(i.name))) / 5.0, 0.25)
			i.get_node("Current").position.x = i.width + 100
		else:
			pass

func change_value(value):
	var i = list.get_child(select2).text.to_lower()
	var valuetext = list.get_child(select2).get_node("Current")
	var itemtype = Setting.setting.category[selecting][i]["type"]
	
	match itemtype:
		"bind":
			valuetext.text = str(Setting.setting.category[selecting][i]["cur"]).replace("[", "").replace("]", "").replace(",", "").replace("\"", "")
		"bool":
			if Setting.s_get(selecting, i):
				Setting.s_set(selecting, i, false)
				valuetext.text = str(Setting.setting.category[selecting][i]["cur"])
			else:
				Setting.s_set(selecting, i, true)
				valuetext.text = str(Setting.setting.category[selecting][i]["cur"])
		"array":
			Setting.s_set_array(selecting, i, value)
			var current_value = Setting.setting.category[selecting][i]["cur"]
			valuetext.text = str(Setting.setting.category[selecting][i]["array"][current_value])
		"int_range":
			var range_min = Setting.setting.category[selecting][i]["range"][0]
			var range_max = Setting.setting.category[selecting][i]["range"][1]
			while Input.is_action_pressed("game_ui_left") or Input.is_action_pressed("game_ui_right"):
				await get_tree().create_timer(Setting.setting.category[selecting][i]["changesec"]).timeout
				Setting.s_set(selecting, i, clamp(Setting.setting.category[selecting][i]["cur"] + value * Setting.setting.category[selecting][i]["step"], range_min, range_max))
				valuetext.text = str(Setting.setting.category[selecting][i]["cur"])
	
	

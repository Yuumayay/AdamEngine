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
		var new_item: Label = template.duplicate()
		var itemname = i
		
		new_item.name = str(ind)
		new_item.data = itemname
		
		Setting.set_dfont(new_item)
		
		new_item.text = Setting.translate(itemname)
		new_item.ind = ind
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count = list.get_child_count() - 1

func option():
	var ind := 0
	var selected_name
	if list.get_child_count() == 0:
		selected_name = selecting
	else:
		selected_name = list.get_child(select).data.to_lower()
	var json = Setting.setting.category[selected_name]
	for i in list.get_children():
		list.remove_child(i)
	for i in json:
		var new_item
		
		if Setting.eng():
			new_item = template2.duplicate()
		else:
			new_item = template.duplicate()
		
		var valuetext = new_item.get_node("Current")
		var itemname = i
		var current = Setting.setting.category[selected_name][i]["cur"]
		var itemtype = Setting.setting.category[selected_name][i]["type"]
		
		new_item.name = str(ind)
		Setting.set_dfont(new_item)
		new_item.text = Setting.translate(itemname)
		
		if !Setting.eng():
			new_item.data = itemname
			valuetext.show()
			
		
		match itemtype:
			# typeがbindだったら
			"bind":
				var new_node = Node2D.new()
				new_node.name = "BindTexts"
				new_item.add_child(new_node)
				
				if !Setting.eng():
					new_item.text = Setting.translate("bind")
				else:
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
					note.visible = true
					if !Setting.eng():
						k.position.y -= 50
						note.position.y += 50
					k.add_child(note)
					new_node.add_child(k)
				keytext.text = str(key) + "k"
				keytext.position = Vector2(190, 10)
				keytext.scale = Vector2(0.8, 0.8)
				
				new_item.value = key
				new_item.add_child(keytext)
				if !Setting.eng():
					keytext.position.y -= 50
					keytext.position.x += 10
			# typeがarrayだったら
			"array":
				if !Setting.eng():
					valuetext.text = Setting.translate(Setting.setting.category[selected_name][i]["array"][current])
				else:
					valuetext.text = Setting.setting.category[selected_name][i]["array"][current]
			"bool":
				if current:
					if !Setting.eng():
						valuetext.text = Setting.translate(str(current))
					else:
						valuetext.text = "on"
				else:
					if !Setting.eng():
						valuetext.text = Setting.translate(str(current))
					else:
						valuetext.text = "off"
			#それ以外
			_:
				valuetext.text = str(current)
		
		new_item.scale = Vector2(0.5,0.5)
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
			elif layer == 1:
				if select2 == 0:
					select2 = child_count2
				else:
					select2 -= 1
			else:
				if select3 == 0:
					select3 = child_count3
				else:
					select3 -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if layer == 0:
				if select == child_count:
					select = 0
				else:
					select += 1
			elif layer == 1:
				if select2 == child_count2:
					select2 = 0
				else:
					select2 += 1
			else:
				if select3 == child_count3:
					select3 = 0
				else:
					select3 += 1
		if Input.is_action_just_pressed("game_ui_left"):
			Audio.a_scroll()
			if selecting == "keybind":
				if layer == 1:
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
				if layer < 2:
					$Alphabet.show()
					child_count3 = list.get_node(str(select2)).value - 1
					layer += 1
				else:
					list.get_node(str(select2)).get_node("BindTexts").get_child(select3).hide()
					Game.can_input = false
			else:
				if layer == 0:
					selecting = list.get_child(select).data.to_lower()
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
				select3 = 0
				$Alphabet.hide()
				layer -= 1
	if list.get_child_count() != 0:
		update_position()

func _unhandled_key_input(event):
	if not Game.can_input and selecting == "keybind" and not event.is_released():
		var keyCount = list.get_node(str(select2)).value
		var bind = Setting.setting.category[selecting][str(list.get_node(str(select2)).value) + "k bind"]["cur"]
		var bindtext = list.get_node(str(select2)).get_node("BindTexts").get_child(select3)
		Audio.a_cancel()
		bind[select3] = event.as_text()
		Setting.s_set("keybind", str(keyCount) + "k bind", bind)
		print(bind)
		bindtext.text = bind[select3]
		bindtext.show()
		await get_tree().create_timer(0).timeout
		Game.can_input = true

func update_position():
	for i in list.get_children():
		if layer == 0:
			i.position.x = 440
			if !Setting.eng():
				i.position.y = lerp(i.position.y, -select * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
			else:
				i.position.y = lerp(i.position.y, -select * 150.0 + (350.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - int(String(i.name))) / 5.0, 0.25)
		elif layer == 1:
			if Setting.rev_translate(i.text) == "bind":
				i.position.x = lerp(i.position.x, -select2 * 400 + (500.0 + int(String(i.name)) * 400), 0.25)
				i.position.y = 100
			else:
				i.position.x = 240
				if !Setting.eng():
					i.position.y = lerp(i.position.y, -select2 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
				else:
					i.position.y = lerp(i.position.y, -select2 * 150.0 + (350.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select2 - int(String(i.name))) / 5.0, 0.25)
			if Setting.eng():
				i.get_node("Current").position.x = i.width + 100
			else:
				i.get_node("Current").position.x = i.size.x + 50
		else:
			if Setting.rev_translate(i.text) == "bind":
				i.position.x = lerp(i.position.x, -select2 * 400 + (500.0 + int(String(i.name)) * 400), 0.25)
				i.position.y = lerp(i.position.y, -select3 * 100.0 + 200.0, 0.25)

func change_value(value):
	var i
	if !Setting.eng():
		i = list.get_child(select2).data.to_lower()
	else:
		i = list.get_child(select2).text.to_lower()
	var valuetext = list.get_child(select2).get_node("Current")
	var itemtype = Setting.setting.category[selecting][i]["type"]
	
	match itemtype:
		"bind":
			valuetext.text = str(Setting.setting.category[selecting][i]["cur"]).replace("[", "").replace("]", "").replace(",", "").replace("\"", "")
		"bool":
			if Setting.jpn():
				if Setting.s_get(selecting, i):
					Setting.s_set(selecting, i, false)
					valuetext.text = "オフ"
				else:
					Setting.s_set(selecting, i, true)
					valuetext.text = "オン"
			else:
				if Setting.s_get(selecting, i):
					Setting.s_set(selecting, i, false)
					valuetext.text = "off"
				else:
					Setting.s_set(selecting, i, true)
					valuetext.text = "on"
		"array":
			if selecting == "language":
				Game.can_input = false
				for ind in list.get_children():
					list.remove_child(ind)
				Setting.s_set_array(selecting, i, value)
				await get_tree().create_timer(0.02).timeout
				option()
				var current_value = Setting.setting.category[selecting][i]["cur"]
				if !Setting.eng():
					valuetext.text = Setting.translate(str(Setting.setting.category[selecting][i]["array"][current_value]))
				else:
					str(Setting.setting.category[selecting][i]["array"][current_value])
				Game.can_input = true
			else:
				Setting.s_set_array(selecting, i, value)
				var current_value = Setting.setting.category[selecting][i]["cur"]
				if !Setting.eng():
					valuetext.text = Setting.translate(str(Setting.setting.category[selecting][i]["array"][current_value]))
				else:
					valuetext.text = str(Setting.setting.category[selecting][i]["array"][current_value])
		"int_range":
			var range_min = Setting.setting.category[selecting][i]["range"][0]
			var range_max = Setting.setting.category[selecting][i]["range"][1]
			while Input.is_action_pressed("game_ui_left") or Input.is_action_pressed("game_ui_right"):
				if Input.is_action_pressed("game_shift"):
					await get_tree().create_timer(Setting.setting.category[selecting][i]["changesec"]).timeout
					Setting.s_set(selecting, i, clamp(Setting.setting.category[selecting][i]["cur"] + value * Setting.setting.category[selecting][i]["step"] * 4, range_min, range_max))
					valuetext.text = str(Setting.setting.category[selecting][i]["cur"])
				else:
					await get_tree().create_timer(Setting.setting.category[selecting][i]["changesec"]).timeout
					Setting.s_set(selecting, i, clamp(Setting.setting.category[selecting][i]["cur"] + value * Setting.setting.category[selecting][i]["step"], range_min, range_max))
					valuetext.text = str(Setting.setting.category[selecting][i]["cur"])
	
	

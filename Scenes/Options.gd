extends Node2D

@onready var list = get_node("Selectable")
@onready var template = get_node("Template")
@onready var template2 = get_node("Template2")
@onready var desc = $Layer/Description
@onready var desc2 = $Layer/Description2

var select: int = 0
var child_count: int = 0
var select2: int = 0
var child_count2: int = 0
var layer: int = 0
var selecting: String
var select3: int = 0
var child_count3: int = 0
var select4: int = 0
var child_count4: int = 0

var selecting_name: String
var gf_spr

func _ready():
	category()
	Audio.a_stop("Freaky Menu")
	Audio.a_play("Option Menu")
	gf_spr = Game.load_XMLSprite("Assets/Images/Dialogue/Characters/girlfriend.xml", "girlfriend neutral")
	gf_spr.position = Vector2(1100, 500)
	gf_spr.scale = Vector2(1.5, 1.5)
	gf_spr.set_script(load("res://Script/OptionGF.gd"))
	add_child(gf_spr)
	var bubble = Game.load_XMLSprite("Assets/Images/Dialogue/speech_bubble.xml", "speech bubble normal")
	bubble.position = Vector2(650, 640)
	bubble.scale = Vector2(1, 0.5)
	add_child(bubble)

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
	var selectList = [select, select2, select3, select4]
	var ind := 0
	var selected_name
	if list.get_child_count() == 0:
		selected_name = selecting
	else:
		if "data" in list.get_child(selectList[layer]):
			if selecting == "visuals and ui":
				selected_name = selecting
			else:
				selected_name = list.get_child(selectList[layer]).data.to_lower()
		else:
			selected_name = selecting
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
		
		new_item.data = itemname
		
		if !Setting.eng():
			valuetext.show()
		else:
			valuetext.position.y += 25
		
		match itemtype:
			"engineType":
				if layer == 0 or layer == 1:
					for index in Setting.setting.category[selected_name][i]["metadata"]:
						for indexind in Setting.setting.category[selected_name][i]["array"]:
							#print(indexind.data[indexind.metadata.find(index)])
							valuetext.text = Setting.translate(indexind.data[indexind.metadata.find(index)])
				elif layer == 2:
					var index := 0
					for type in Setting.setting.category[selected_name][i]["array"]:
						if !Setting.eng():
							new_item.text = Setting.translate(type.name)
						else:
							new_item.text = type.name
						new_item.name = str(index)
						list.add_child(new_item.duplicate())
						index += 1
					new_item.value = index
					return
				elif layer == 3:
					var index := 0
					var type = Setting.setting.category[selected_name][i]["array"][select3]
					for data in type.data:
						if !Setting.eng():
							new_item.text = Setting.translate(data)
						else:
							new_item.text = data
						new_item.name = str(index)
						list.add_child(new_item.duplicate())
						index += 1
					new_item.value = index
					return
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
					var note = Game.load_XMLSprite("Assets/Images/Notes/Default/default.xml")
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
		
		new_item.scale = Vector2(1,1)
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count2 = list.get_child_count() - 1

var last_selecting := ""

var gf_speak_stop := false

func gf_speak(text: String):
	var description
	if Setting.jpn():
		desc.show()
		desc2.hide()
		text = "[center]" + text + "[/center]"
		description = desc
		desc.add_theme_color_override("default_color", "white")
		desc.add_theme_color_override("font_outline_color", Color("bc1876"))
		desc.add_theme_color_override("font_shadow_color", "black")
		desc.add_theme_font_override("normal_font", load("res://Assets/Fonts/BugMaru.ttc"))
		desc.add_theme_constant_override("outline_size", 5)
		desc.add_theme_constant_override("shadow_outline_size", 6)
	else:
		desc.hide()
		desc2.show()
		description = desc2
	if not Audio.has_node("gf"):
		var gfsound = AudioStreamPlayer.new()
		gfsound.stream = load("Assets/Sounds/Dialogue/gf.ogg")
		gfsound.name = "gf"
		Audio.add_child(gfsound)
	
	description.text = ""
	var bbcode := false
	
	gf_spr.play("girlfriend neutral")
	var bbcode_text := ""
	for i in text:
		if gf_speak_stop or Game.trans:
			return
		description.text += i
		if i == "]":
			if bbcode_text == "wait":
				gf_spr.stop()
				description.text = description.text.replacen("["+bbcode_text+"]", "")
				for index in range(50):
					if gf_speak_stop or Game.trans:
						return
					await get_tree().create_timer(0).timeout
				gf_spr.play(gf_spr.animation)
			if gf_spr.sprite_frames.has_animation("girlfriend "+bbcode_text):
				gf_spr.play("girlfriend "+bbcode_text)
				description.text = description.text.replacen("["+bbcode_text+"]", "")
			if gf_spr.sprite_frames.has_animation("girlfreind "+bbcode_text):
				gf_spr.play("girlfreind "+bbcode_text)
				description.text = description.text.replacen("["+bbcode_text+"]", "")
			bbcode_text = ""
			bbcode = false
		if bbcode:
			bbcode_text += i
		if i == "[":
			bbcode = true
		if !bbcode:
			Audio.a_play("gf")
			await get_tree().create_timer(0).timeout
	gf_spr.stop()

func _process(_delta):
	var selectList = [select, select2, select3, select4]
	var child = list.get_child(selectList[layer])
	if child:
		selecting_name = child.data
	if last_selecting != selecting_name:
		last_selecting = selecting_name
		gf_speak_stop = true
		await get_tree().create_timer(0).timeout
		gf_speak_stop = false
		var desc_dict = Setting.desc
		if Setting.jpn():
			Setting.set_dfont_mini(desc)
			desc_dict = Setting.descJPN
		if desc_dict.has(selecting_name):
			gf_speak(desc_dict[selecting_name])
		else:
			desc.text = ""
			desc2.text = ""
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
			elif layer == 2:
				if select3 == 0:
					select3 = child_count3
				else:
					select3 -= 1
			else:
				if select4 == 0:
					select4 = child_count4
				else:
					select4 -= 1
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
			elif layer == 2:
				if select3 == child_count3:
					select3 = 0
				else:
					select3 += 1
			else:
				if select4 == child_count4:
					select4 = 0
				else:
					select4 += 1
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
			elif selecting == "visuals and ui":
				if layer == 0:
					layer += 1
					option()
					child_count2 = list.get_child_count() - 1
				elif layer == 1:
					layer += 1
					option()
					child_count3 = list.get_child_count() - 1
				elif layer == 2:
					layer += 1
					option()
					child_count4 = list.get_child_count() - 1
				else:
					Flash.flash(Color("FFFFFF"), 3)
					layer -= 2
					option()
					var size_total := 0
					for index in range(select3):
						size_total += Setting.setting.category["visuals and ui"]["engine type"]["array"][index]["metadata"].size()
					print(select4 + size_total)
					Setting.s_set("visuals and ui", "engine type", select4 + size_total)
					select3 = 0
					select4 = 0
			else:
				if layer == 0:
					selecting = list.get_child(select).data.to_lower()
					option()
					layer += 1
				else:
					change_value(1)
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
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
			elif layer == 2:
				if selecting == "keybind":
					select3 = 0
					$Alphabet.hide()
					layer -= 1
				else:
					select3 = 0
					layer -= 1
					option()
			else:
				select4 = 0
				layer -= 1
				option()
		if Input.is_action_just_pressed("game_talk_gf"):
			gf_speak_stop = true
			await get_tree().create_timer(0).timeout
			gf_speak_stop = false
			var desc_dict = View.gfspeak
			if Setting.jpn():
				Setting.set_dfont_mini(desc)
				desc_dict = View.gfspeakJPN
			var rand = randi_range(0, 100)
			var rare = "common"
			if rand >= 90:
				if rand == 100:
					rare = "very_rare"
				else:
					rare = "rare"
			gf_speak(desc_dict[rare][randi_range(0, desc_dict[rare].size() - 1)])
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
				i.position.x = 50
				if !Setting.eng():
					i.position.y = lerp(i.position.y, -select2 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
				else:
					i.position.y = lerp(i.position.y, -select2 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select2 - int(String(i.name))) / 5.0, 0.25)
			if Setting.eng():
				i.get_node("Current").position.x = i.width + 100
			else:
				i.get_node("Current").position.x = i.size.x + 50
		elif layer == 2:
			if Setting.rev_translate(i.text) == "bind":
				i.position.x = lerp(i.position.x, -select2 * 400 + (500.0 + int(String(i.name)) * 400), 0.25)
				i.position.y = lerp(i.position.y, -select3 * 100.0 + 200.0, 0.25)
			else:
				i.position.x = 50
				if !Setting.eng():
					i.position.y = lerp(i.position.y, -select3 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
				else:
					i.position.y = lerp(i.position.y, -select3 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
				i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select3 - int(String(i.name))) / 3.0, 0.25)
		else:
			i.position.x = 50
			if !Setting.eng():
				i.position.y = lerp(i.position.y, -select4 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
			else:
				i.position.y = lerp(i.position.y, -select4 * 150.0 + (300.0 + int(String(i.name)) * 150.0), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select4 - int(String(i.name))) / 3.0, 0.25)

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
	
	

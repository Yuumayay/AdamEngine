extends Node2D

@onready var bg = get_node("BG")
@onready var list = get_node("Selectable")
@onready var desc = $Panel/Desc

var select: int = 0
var child_count: int = 0

func _ready():
	var ind := 0
	var json = File.f_read("Assets/Data/Credits/credits.json", ".json")
	var read_property = Setting.get_translate(json, "peoples")
	if Setting.jpn():
		desc.add_theme_font_override("font", load("Assets/Fonts/BugMaru.ttc"))
		desc.add_theme_color_override("font_outline_color", Color(0.5, 0.5, 0.5))
		desc.add_theme_constant_override("shadow_outline_size", 5)
		desc.add_theme_color_override("font_shadow_color", Color(0, 0, 0))
	for i in read_property:
		var new_item = $Alphabet.duplicate()
		var itemname = i[0]
		if i.size() != 1:
			var itemdesc = i[1]
			var itemdesc2 = i[2]
			var itemcolor: Color = Color(i[3][0] / 255.0, i[3][1] / 255.0, i[3][2] / 255.0, 1)
			var itemurl
			if i.size() - 1 == 4:
				itemurl = i[4]
			
			new_item.name = itemname
			new_item.text = itemname
			new_item.value = ind
			new_item.color = itemcolor
			new_item.name = itemname
			new_item.string = itemurl
			desc.text = itemdesc + "\n" + " " + "\n" + itemdesc2
			if itemdesc2 != "":
				desc.text += "\n- " + itemname
		else:
			new_item.type = 1
			new_item.name = itemname
			new_item.text = itemname.to_upper()
			new_item.value = ind
		
		var icon = Paths.p_icon_credits(itemname)
		if icon.get_size() == Vector2(150, 150):
			new_item.get_node("Icon").hframes = 1
		elif icon.get_size() == Vector2(300, 150):
			new_item.get_node("Icon").hframes = 2
		elif icon.get_size() == Vector2(450, 150):
			new_item.get_node("Icon").hframes = 3
		new_item.get_node("Icon").texture = icon
		new_item.get_node("Icon").position.x += itemname.length() * 54.5
		
		new_item.visible = true
		list.add_child(new_item)
		ind += 1
	
	child_count = list.get_child_count() - 1

func _process(_delta):
	if Game.can_input:
		if Input.is_action_just_pressed("game_ui_up"):
			Audio.a_scroll()
			if select == 0:
				select = child_count
			else:
				select -= 1
		if Input.is_action_just_pressed("game_ui_down"):
			Audio.a_scroll()
			if select == child_count:
				select = 0
			else:
				select += 1
		if Input.is_action_just_pressed("ui_accept"):
			Audio.a_scroll()
			if list.get_child(select).string:
				OS.shell_open(list.get_child(select).string)
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Trans.t_trans("Main Menu")
	update_position()

func update_position():
	for i in list.get_children():
		if i == list.get_child(select):
			bg.modulate = lerp(bg.modulate, i.color, 0.05)
		i.position.x = lerp(i.position.x, abs(select - i.value) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (300.0 + i.value * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.value) / 5.0, 0.25)

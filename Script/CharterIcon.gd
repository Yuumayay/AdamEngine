extends Sprite2D

@export var icon_name: String
@export var p_type: String
@export var p_ind: int
@export var key_count: int

@onready var sceneroot = $/root/"Chart Editor"/Mass

func init():
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 40)
	label.add_theme_font_override("font", load("Assets/Fonts/vcr.ttf"))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_constant_override("outline_size", 10)
	label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	label.grow_vertical = Control.GROW_DIRECTION_END
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if p_type != "EVENT":
		label.text = icon_name + "\n" + p_type + "-" + str(p_ind + 1)
	else:
		label.text = p_type
	label.position.y = 80
	add_child(label)
	
	var button = Button.new()
	button.size = Vector2(150, 150)
	button.position = Vector2(-75, -75)
	button.modulate.a = 0.25
	
	var menubutton = MenuButton.new()
	menubutton.size = Vector2(150, 150)
	menubutton.position = Vector2(-75, -75)
	menubutton.button_down.connect(menubutton_pressed)
	menubutton.mouse_exited.connect(menubutton_exited)
	
	var popup = menubutton.get_popup()
	
	if p_type != "EVENT":
		var subpopup = PopupMenu.new()
		subpopup.name = "modchart"
		var subpopup2 = PopupMenu.new()
		subpopup2.name = "keycount"
		
		popup.add_item("Add " + p_type.to_lower())
		popup.add_separator()
		popup.add_item("Clone " + icon_name)
		popup.add_separator()
		popup.add_item("Set character")
		popup.add_separator()
		popup.add_item("Set keycount")
		popup.add_separator()
		popup.add_item("Set arrow skin")
		popup.add_separator()
		popup.add_item("Set modchart")
		popup.add_separator()
		popup.add_item("Follow camera")
		popup.add_separator()
		popup.add_item("Clear notes")
		popup.add_separator()
		popup.add_item("Clear all notes")
		if p_ind != 0:
			popup.add_separator()
			popup.add_item("Erase character")
		
		popup.add_child(subpopup)
		popup.set_item_submenu(10, "modchart")
		subpopup.add_item("Health drain")
		
		popup.add_child(subpopup2)
		popup.set_item_submenu(6, "keycount")
		subpopup2.add_item("1k")
		subpopup2.add_item("2k")
		subpopup2.add_item("3k")
		subpopup2.add_item("4k")
		subpopup2.add_item("5k")
		subpopup2.add_item("6k")
		subpopup2.add_item("7k")
		subpopup2.add_item("8k")
		subpopup2.add_item("9k")
		subpopup2.add_item("10k")
		subpopup2.add_item("11k")
		subpopup2.add_item("12k")
		subpopup2.add_item("13k")
		subpopup2.add_item("14k")
		subpopup2.add_item("15k")
		subpopup2.add_item("16k")
		subpopup2.add_item("17k")
		subpopup2.add_item("18k")
		subpopup.id_pressed.connect(modchart_pressed)
		subpopup2.id_pressed.connect(keycount_pressed)
	else:
		popup.add_item("Clear section event")
		popup.add_separator()
		popup.add_item("Clear all event")
	
	popup.id_pressed.connect(item_pressed)
	
	add_child(button)
	add_child(menubutton)

func item_pressed(id):
	if p_type != "EVENT":
		if id == 0:
			sceneroot.add_character(p_type)
		elif id == 2:
			sceneroot.clone_character(p_type, icon_name, key_count)
		elif id == 4:
			sceneroot.set_character(p_type, p_ind, "face")
		elif id == 8:
			sceneroot.set_note_skin(p_type, p_ind, "face")
		elif id == 18:
			sceneroot.erase_character(p_type, p_ind)

func modchart_pressed(id):
	sceneroot.set_modchart(p_type, p_ind, id + 1)

func keycount_pressed(id):
	sceneroot.set_key_count(p_type, p_ind, id + 1)

func menubutton_pressed():
	pass

func menubutton_exited():
	pass

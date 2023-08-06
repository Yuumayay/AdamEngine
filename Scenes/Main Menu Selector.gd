extends Node2D

var select: int = 0
var child_count: int = 0
var is_accepted: bool = false

var main_menu_offset = File.f_read(Paths.p_offset("Main Menu/Offset.json"), ".json")
var selectable: Array = main_menu_offset.SelectableList

func _ready():
	var ind = 0
	for i in selectable:
		var new_selectable: Node2D = get_parent().get_node("Template").duplicate()
		new_selectable.position.y = 100 + ind * 150
		#new_selectable.texture = load("res://Assets/Images/Main Menu/" + i.to_lower() + " placeholder.png")
		new_selectable.name = i
		new_selectable.visible = true
		ind += 1
		add_child(new_selectable)
	child_count = get_child_count() - 1

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
			Game.can_input = false
			Audio.a_accept()
			for i in get_children():
				if i == get_child(select):
					i.accepted(true)
				else:
					i.accepted(false)
		if Input.is_action_just_pressed("ui_cancel"):
			Game.can_input = false
			Audio.a_cancel()
			Trans.t_trans("Title Menu")
		if Input.is_action_just_pressed("game_debug"):
			Audio.a_stop("Freaky Menu")
			Trans.t_trans("Debug Menu")
	update_position()

func update_position():
	for i in get_children():
		if i == get_child(select):
			i.scale = lerp(i.scale, Vector2(0.8, 0.8), 0.25)
			i.modulate.a = lerp(i.modulate.a, 1.0, 0.25)
		else:
			i.scale = lerp(i.scale, Vector2(0.75, 0.75), 0.25)
			i.modulate.a = lerp(i.modulate.a, 0.75, 0.25)

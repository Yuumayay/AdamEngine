extends Node2D

@onready var bg = get_node("BG")
@onready var list = get_node("Selectable")

var select: int = 0
var child_count: int = 0

func _ready():
	Audio.a_play("Debug Menu")
	var ind := 0
	var json = File.f_read(Paths.p_offset("Debug Menu/Offset.json"), ".json")
	for i in json.SelectableList:
		var new_item = $Template.duplicate()
		var itemname = i
		
		new_item.name = itemname
		new_item.text = "[shake rate=10 level=20]" + itemname.to_upper() + "[/shake]"
		new_item.ind = ind
		new_item.name = itemname
		
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
			Audio.a_accept()
			for i in list.get_children():
				if i == list.get_child(select):
					i.accepted(true)
				else:
					i.accepted(false)
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.a_cancel()
			Audio.a_stop("Debug Menu")
			Audio.a_title()
			Trans.t_trans("Main Menu")
	update_position()

func update_position():
	for i in list.get_children():
		i.position.x = lerp(i.position.x, abs(select - i.ind) * -25.0 + 225.0, 0.25)
		i.position.y = lerp(i.position.y, -select * 150.0 + (350.0 + i.ind * 150.0), 0.25)
		i.modulate.a = lerp(i.modulate.a, 1.0 - abs(select - i.ind) / 5.0, 0.25)

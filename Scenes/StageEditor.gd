extends Node2D

@onready var f_dialog = $UI/FileDialog
@onready var sprite_group = $Sprites

var stage_editor_sprite = preload("StageEditorSprite.tscn")
var instance_spr
var can_input := true

func _ready():
	instance_spr = stage_editor_sprite.instantiate()
	f_dialog.add_filter("*.png", "Image")
	f_dialog.add_filter("*.xml", "Animated Image")
	Audio.a_play("Option Menu")


func _on_add_sprite_pressed():
	can_input = false
	f_dialog.show()

func _on_file_dialog_file_selected(path):
	can_input = true
	if path.get_extension() == "png":
		var new_spr = instance_spr.duplicate()
		new_spr.image_path = path
		new_spr.position = Vector2(View.SCREEN_X / 2.0, View.SCREEN_Y / 2.0)
		sprite_group.add_child(new_spr)
	elif path.get_extension() == "xml":
		var new_spr = instance_spr.duplicate()
		new_spr.xml_path = path
		new_spr.position = Vector2(View.SCREEN_X / 2.0, View.SCREEN_Y / 2.0)
		sprite_group.add_child(new_spr)


func _on_file_dialog_close_requested():
	can_input = true

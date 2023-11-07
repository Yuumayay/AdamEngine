extends Node2D

@onready var f_dialog = $UI/FileDialog
@onready var sprite_group = $Sprites

var stage_editor_sprite = preload("StageEditorSprite.tscn")
var instance_spr
var can_input := true

var chara_path = ["Assets/Images/Characters/BOYFRIEND.xml", "Assets/Images/Characters/GF_assets.xml", "Assets/Images/Characters/DADDY_DEAREST.xml"]

func _ready():
	instance_spr = stage_editor_sprite.instantiate()
	f_dialog.add_filter("*.png", "Image")
	f_dialog.add_filter("*.xml", "Animated Image")
	Audio.a_play("Pause Menu")
	set_character()

func set_character():
	for path in chara_path:
		var new_spr = instance_spr.duplicate()
		new_spr.xml_path = path
		new_spr.position = Vector2(View.SCREEN_X / 2.0, View.SCREEN_Y / 2.0)
		sprite_group.add_child(new_spr)

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

func saveJSON():
	var content := {
		"defaultZoom": 1,
		"isPixelStage": false,
		"boyfriend": [0, 0],
		"girlfriend": [0, 0],
		"opponent": [0, 0],
		"hide_girlfriend": false,
		"camera_boyfriend": [0, 0],
		"camera_opponent": [0, 0],
		"camera_girlfriend": [0, 0],
		"camera_speed": 1,
		"stageData": []
		}
	for spr in sprite_group.get_children():
		var sprData: Dictionary
		sprData["tag"] = spr.name
		print(spr.image_path.get_file())
		if spr.animated:
			sprData["path"] = spr.xml_path.get_file().replace(".png", "")
		else:
			sprData["path"] = spr.image_path.get_file().replace(".xml", "")
		sprData["pos"] = spr.position
		sprData["z"] = spr.z_index
		sprData["flip_x"] = spr.flip_h
		sprData["flip_y"] = spr.flip_v
		sprData["modulate"] = spr.self_modulate
		#content.stageData.append()

func _on_file_dialog_close_requested():
	can_input = true

func _on_save_json_pressed():
	saveJSON()

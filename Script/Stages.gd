extends Node2D

var sNode: Node

func _ready():
	await Modchart.modchart_ready
	
	var stageJSON = Game.stage
	if stageJSON.has("stageData"):
		for i in stageJSON.stageData:
			print("stageData: ", i)
			var spr
			var anim
			var path
			var tag = Game.check_property_and_set(i, "tag", "unnamed")
			var img = Game.check_property_and_set(i, "path", "UI/Missing")
			var posArray = Game.check_property_and_set(i, "pos", [0, 0])
			var scaleArray = Game.check_property_and_set(i, "scale", [1, 1])
			var sortInd = Game.check_property_and_set(i, "z", 0)
			var flipX = Game.check_property_and_set(i, "flip_x", false)
			var cam = Game.check_property_and_set(i, "cam", "")
			if Game.is3D:
				spr = Sprite3D.new()
				
				# json内のarrayから位置を設定(3D)
				if posArray.size() == 3:
					spr.position = Vector3(posArray[0], posArray[1], posArray[2])
				elif posArray.size() == 2:
					spr.position = Vector3(posArray[0], posArray[1], 0)
				else:
					spr.position = Vector3(0, 0, 0)
					printerr("uncorrect position array size")
				
				# json内のarrayからスケールを設定(3D)
				if scaleArray.size() == 3:
					spr.scale = Vector3(scaleArray[0], scaleArray[1], scaleArray[2])
				elif posArray.size() == 2:
					spr.scale = Vector3(scaleArray[0], scaleArray[1], 1)
				else:
					spr.scale = Vector3(1, 1, 1)
					printerr("uncorrect scale array size")
				
				# 重ね順を設定(3D)
				spr.sorting_offset = sortInd
				spr.centered = false
				spr.flip_h = flipX
				
				if FileAccess.file_exists("Assets/Images/" + img + ".png"):
					spr.texture = Game.load_image("Assets/Images/" + img + ".png")
				else:
					spr.texture = Game.load_image("Mods/Images/" + img + ".png")
				
			elif cam == "screen":
				spr = CanvasLayer.new()
				spr.layer = sortInd
				var texRect = TextureRect.new()
				if FileAccess.file_exists("Assets/Images/" + img + ".png"):
					texRect.texture = Game.load_image("Assets/Images/" + img + ".png")
				else:
					texRect.texture = Game.load_image("Mods/Images/" + img + ".png")
				texRect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				spr.add_child(texRect)
			else:
				if FileAccess.file_exists("Assets/Images/" + img + ".xml"):
					path = "Assets/Images/" + img + ".xml"
					anim = true
					spr = Game.load_XMLSprite(path)
				elif FileAccess.file_exists("Mods/Images/" + img + ".xml"):
					path = "Mods/Images/" + img + ".xml"
					anim = true
					spr = Game.load_XMLSprite(path)
				else:
					spr = Sprite2D.new()
				
				# json内のarrayから位置を設定(2D)
				if posArray.size() == 2:
					spr.position = Vector2(posArray[0], posArray[1])
				else:
					spr.position = Vector2(0, 0)
					printerr("uncorrect position array size")
				
				# json内のarrayからスケールを設定(2D)
				if scaleArray.size() == 2:
					spr.scale = Vector2(scaleArray[0], scaleArray[1])
				else:
					spr.scale = Vector2(1, 1)
					printerr("uncorrect scale array size")
				
				# 重ね順を設定(2D)
				spr.z_index = sortInd
				spr.centered = false
				spr.flip_h = flipX
				if not anim:
					if FileAccess.file_exists("Assets/Images/" + img + ".png"):
						spr.texture = Game.load_image("Assets/Images/" + img + ".png")
					else:
						spr.texture = Game.load_image("Mods/Images/" + img + ".png")
			
			spr.name = tag
			add_child(spr)
	else:
		if Paths.p_stage_script(Game.cur_stage):
			var scriptPath = Paths.p_stage_script(Game.cur_stage)
			
			print(scriptPath)
			
			if scriptPath.get_extension() == "lua":
				File.f_save("user://ae_stage_script_temp", ".gd", File.lua_2_gd(File.f_read(scriptPath, ".lua")))
				scriptPath = "user://ae_stage_script_temp" + ".gd"
			
			var scr: Script = load(scriptPath)
			sNode = $/root/Gameplay/StageScript
			sNode.set_script(scr)
			
			if sNode.has_method("onCreate"):
				sNode.call("onCreate")

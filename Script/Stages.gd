extends Node2D

var sNode: Node

func _ready():
	await Modchart.modchart_ready
	
	var stageJSON = Game.stage
	if stageJSON.has("stageData"):
		for i in stageJSON.stageData:
			print("stageData: ", i)
			var spr
			var tag = i[0]
			var img = i[1]
			var posArray = i[2]
			var scaleArray = i[3]
			var sortInd = i[4]
			var flipX = i[5]
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
			
			spr.name = tag
			spr.texture = Game.load_image("Assets/Images/Stages/" + img)
			spr.flip_h = flipX
			add_child(spr)
	else:
		if Paths.p_stage_script(Game.cur_stage):
			var scriptPath = Paths.p_stage_script(Game.cur_stage)
			
			print(scriptPath)
			
			if scriptPath.get_extension() == "lua":
				File.f_save(scriptPath.get_basename(), ".gd", File.lua_2_gd(File.f_read(scriptPath, ".lua")))
				scriptPath = scriptPath.get_basename() + ".gd"
			
			var scr: Script = load(scriptPath)
			sNode = $/root/Gameplay/StageScript
			sNode.set_script(scr)
			
			if sNode.has_method("onCreate"):
				sNode.call("onCreate")

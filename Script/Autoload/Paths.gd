extends Node

var missing = "res://Assets/Images/UI/Missing.png"

var song_path_list: Array = ["res://Assets/Songs/", "res://Mods/songs/"]
var chart_path_list: Array = ["res://Assets/Songs/", "res://Mods/songs/", "res://Assets/Data/Song Charts/", "res://Mods/data/song charts/", "res://Mods/data/", "res://Mods/data/song data/"]
var icon_path_list: Array = ["res://Assets/Images/Icons/", "res://Mods/images/icons/"]
var icon_credits_path_list: Array = ["res://Assets/Images/Other Icons/Credits/", "res://Mods/images/other icons/credits/", "res://Mods/images/credits/"]
var week_path_list: Array = ["res://Assets/Weeks", "res://mods/weeks"]
var character_data_path_list: Array = ["res://Assets/Data/characters/", "res://mods/data/characters/", "res://mods/characters/"]
var character_image_path_list: Array = ["res://Assets/Images/characters/", "res://mods/images/characters/"]
var stage_data_path_list: Array = ["res://Assets/Data/Stages/", "res://Mods/data/stages/", "res://Mods/stages/"]
var stage_image_path_list: Array = ["res://Assets/Images/Stages/", "res://Mods/images/stages/", "res://Mods/images/"]

func p_offset(path: String):
	return "res://Assets/Data/Settings and Offsets/" + path

func p_song(path: String, path2: String):
	for i in song_path_list:
		var p = i
		if FileAccess.file_exists(p + path + "/" + path2 + ".ogg"):
			return p + path + "/" + path2 + ".ogg"
			
		elif FileAccess.file_exists(p + path.to_lower() + "/" + path2 + ".ogg"):
			return p + path.to_lower() + "/" + path2 + ".ogg"
			
		elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + path2 + ".ogg"):
			return p + path.replace(" ", "-") + "/" + path2 + ".ogg"
			
		elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + path2 + ".ogg"):
			return p + path.to_lower().replace(" ", "-") + "/" + path2 + ".ogg"
			
		elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + path2 + ".ogg"):
			return p + path.replace("-", " ") + "/" + path2 + ".ogg"
			
		elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + path2 + ".ogg"):
			return p + path.to_lower().replace("-", " ") + "/" + path2 + ".ogg"

	Audio.a_play("Error")
	printerr("paths song: invalid path")
	return null

func p_chart(path: String, diff: String):
	for i in chart_path_list:
		var p = i
		if diff == "normal":
			if FileAccess.file_exists(p + path + "/" + path.to_lower() + ".json"):
				return p + path + "/" + path.to_lower() + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower() + "/" + path.to_lower() + ".json"):
				return p + path.to_lower() + "/" + path.to_lower() + ".json"
				
			elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + ".json"):
				return p + path.replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + ".json"):
				return p + path.to_lower().replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + ".json"
				
			elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + path.to_lower().replace("-", " ") + ".json"):
				return p + path.replace("-", " ") + "/" + path.to_lower().replace("-", " ") + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + path.to_lower().replace("-", " ") + ".json"):
				return p + path.to_lower().replace("-", " ") + "/" + path.to_lower().replace("-", " ") + ".json"

		else:
			if FileAccess.file_exists(p + path + "/" + path.to_lower() + "-" + diff + ".json"):
				return p + path + "/" + path.to_lower() + "-" + diff + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower() + "/" + path.to_lower() + "-" + diff + ".json"):
				return p + path.to_lower() + "/" + path.to_lower() + "-" + diff + ".json"
				
			elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + "-" + diff + ".json"):
				return p + path.replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + "-" + diff + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + "-" + diff + ".json"):
				return p + path.to_lower().replace(" ", "-") + "/" + path.to_lower().replace(" ", "-") + "-" + diff + ".json"
				
			elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + path.to_lower().replace("-", " ") + "-" + diff + ".json"):
				return p + path.replace("-", " ") + "/" + path.to_lower().replace("-", " ") + "-" + diff + ".json"
				
			elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + path.to_lower().replace("-", " ") + "-" + diff + ".json"):
				return p + path.to_lower().replace("-", " ") + "/" + path.to_lower().replace("-", " ") + "-" + diff + ".json"
				
	Audio.a_play("Error")
	printerr("paths chart: invalid path")
	return null

func p_modchart(path: String, diff: String):
	for i in chart_path_list:
		var p = i
		if diff == "normal":
			if FileAccess.file_exists(p + path + "/modchart.gd"):
				return p + path + "/modchart.gd"
				
			elif FileAccess.file_exists(p + path.to_lower() + "/modchart.gd"):
				return p + path.to_lower() + "/modchart.gd"
				
			elif FileAccess.file_exists(p + path.replace(" ", "-") + "/modchart.gd"):
				return p + path.replace(" ", "-") + "/modchart.gd"
				
			elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/modchart.gd"):
				return p + path.to_lower().replace(" ", "-") + "/modchart.gd"
				
			elif FileAccess.file_exists(p + path.replace("-", " ") + "/modchart.gd"):
				return p + path.replace("-", " ") + "/modchart.gd"
				
			elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/modchart.gd"):
				return p + path.to_lower().replace("-", " ") + "/modchart.gd"
				
		else:
			if FileAccess.file_exists(p + path + "/modchart-" + diff + ".gd"):
				return p + path + "/modchart-" + diff + ".gd"
				
			elif FileAccess.file_exists(p + path.to_lower() + "/modchart-" + diff + ".gd"):
				return p + path.to_lower() + "/modchart-" + diff + ".gd"
				
			elif FileAccess.file_exists(p + path.replace(" ", "-") + "/modchart-" + diff + ".gd"):
				return p + path.replace(" ", "-") + "/modchart-" + diff + ".gd"
				
			elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/modchart-" + diff + ".gd"):
				return p + path.to_lower().replace(" ", "-") + "/modchart-" + diff + ".gd"
				
			elif FileAccess.file_exists(p + path.replace("-", " ") + "/modchart-" + diff + ".gd"):
				return p + path.replace("-", " ") + "/modchart-" + diff + ".gd"
				
			elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/modchart-" + diff + ".gd"):
				return p + path.to_lower().replace("-", " ") + "/modchart-" + diff + ".gd"
				
	print("paths modchart: no modchart")
	return null

func p_chara(path: String):
	for i in character_data_path_list:
		if FileAccess.file_exists(i + path + ".json"):
			return i + path + ".json"
		elif FileAccess.file_exists(i + path.to_lower() + ".json"):
			return i + path.to_lower() + ".json"
	Audio.a_play("Error")
	printerr("paths character_data: invalid path")
	return null

func p_chara_xml(path: String):
	if path.contains("characters/"): path = path.replace("characters/", "")
	for i in character_image_path_list:
		if FileAccess.file_exists(i + path + ".xml"):
			return i + path + ".xml"
		elif FileAccess.file_exists(i + path.to_lower() + ".xml"):
			return i + path.to_lower() + ".xml"
	Audio.a_play("Error")
	printerr("paths character_xml: invalid path")
	return null

func p_week_image(path: String):
	var p := "res://Assets/Images/Story Mode/Weeks/"
	if path == "tutorial":
		return p + "week0.png"
	else:
		if FileAccess.file_exists(p + path.to_lower().replace(" ", "") + ".png"):
			return p + path.to_lower().replace(" ", "") + ".png"
		else:
			Audio.a_play("Error")
			printerr("paths week image: invalid path")
			return missing

func p_stage_img(path: String):
	for i in stage_image_path_list:
		if FileAccess.file_exists(i + path + ".png"):
			return load(i + path + ".png")
		elif FileAccess.file_exists(i + path.to_lower() + ".png"):
			return load(i + path.to_lower() + ".png")
	Audio.a_play("Error")
	printerr("paths stage image: invalid path")
	return missing

func p_stage_data(path: String):
	for i in stage_data_path_list:
		if FileAccess.file_exists(i + path + ".json"):
			return i + path + ".json"
		elif FileAccess.file_exists(i + path.to_lower() + ".json"):
			return i + path.to_lower() + ".json"
	Audio.a_play("Error")
	printerr("paths stage data: invalid path")
	return null

func p_icon(path: String):
	var icon: Texture2D
	for i in icon_path_list:
		var p = i
		if FileAccess.file_exists(p + path + ".png"):
			icon = load(p + path + ".png")
			return icon
		elif FileAccess.file_exists(p + "icon-" + path + ".png"):
			icon = load(p + "icon-" + path + ".png")
			return icon
		elif FileAccess.file_exists(p + path + "-icons.png"):
			icon = load(p + path + "-icons.png")
			return icon
	printerr("icon: icon not found")
	icon = load("res://Assets/Images/Icons/icon-face.png")
	return icon

func p_icon_credits(path: String):
	var icon: Texture2D
	for i in icon_credits_path_list:
		var p = i
		if FileAccess.file_exists(p + path + ".png"):
			icon = load(p + path + ".png")
			return icon
		elif FileAccess.file_exists(p + "icon-" + path + ".png"):
			icon = load(p + "icon-" + path + ".png")
			return icon
		elif FileAccess.file_exists(p + path + "-icons.png"):
			icon = load(p + path + "-icons.png")
			return icon
	printerr("icon: icon not found")
	icon = load("res://Assets/Images/Icons/icon-face.png")
	return icon

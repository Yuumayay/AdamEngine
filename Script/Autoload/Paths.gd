extends Node

var missing = "res://Assets/Images/UI/Missing.png"

func p_offset(path: String):
	return "res://Assets/Data/Settings and Offsets/" + path

func p_song(path: String, path2: String):
	var p := "res://Assets/Songs/"
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
	
	else:
		Audio.a_play("Error")
		printerr("paths song: invalid path")
		return null

func p_chart(path: String, diff: String):
	var p := "res://Assets/Data/Song Charts/"
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
			Audio.a_play("Error")
			printerr("paths chart: invalid path")
			return null
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
			
		else:
			Audio.a_play("Error")
			printerr("paths chart: invalid path")
			return null

func p_modchart(path: String, diff: String):
	var p := "res://Assets/Data/Song Charts/"
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
			Audio.a_play("Error")
			printerr("paths chart: invalid path")
			return null
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
			
		else:
			Audio.a_play("Error")
			printerr("paths chart: invalid path")
			return null

func p_chara(path: String):
	return "res://Assets/Data/characters/" + path + ".json"

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

func p_icon(path: String):
	var p := "res://Assets/Images/Icons/"
	var p2 := "res://Assets/Images/Icons/icon-"
	var icon: Texture2D
	if FileAccess.file_exists(p + path + ".png"):
		icon = load(p + path + ".png")
	elif FileAccess.file_exists(p2 + path + ".png"):
		icon = load(p2 + path + ".png")
	elif FileAccess.file_exists("res://Assets/Images/Icons/" + path + "-icons.png"):
		icon = load(p + path + "-icons.png")
	else:
		printerr("icon: icon not found")
		icon = load("res://Assets/Images/Icons/icon-face.png")
	return icon

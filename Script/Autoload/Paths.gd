extends Node

var missing = "Assets/Images/UI/Missing.png"

var song_path_list: Array = ["Assets/Songs/", "Mods/songs/"]
var chart_path_list: Array = ["Assets/Songs/", "Mods/songs/", "Assets/Data/Song Charts/", "Mods/data/song charts/", "Mods/data/", "Mods/data/song data/"]
var icon_path_list: Array = ["Assets/Images/Icons/", "Mods/images/icons/"]
var icon_credits_path_list: Array = ["Assets/Images/Other Icons/Credits/", "Mods/images/other icons/credits/", "Mods/images/credits/"]
var week_path_list: Array = ["Assets/Weeks/", "Mods/weeks/"]
var week_image_path_list: Array = ["Assets/Images/Story Mode/Weeks/", "Mods/Images/Story Mode/Weeks/"]
var character_data_path_list: Array = ["Assets/Data/characters/", "Mods/data/characters/", "Mods/characters/"]
var character_image_path_list: Array = ["Assets/Images/characters/", "Mods/images/characters/"]
var stage_data_path_list: Array = ["Assets/Data/Stages/", "Mods/data/stages/", "Mods/stages/"]
var stage_image_path_list: Array = ["Assets/Images/Stages/", "Mods/images/stages/", "Mods/images/"]
var images_path_list: Array = ["Assets/Images/", "Mods/images/"]

var modchart_extensions: Array = [".lua", ".gd"]
var modchart_filenames: Array = ["modchart", "script"]

var load_assets_song: bool

func _ready():
	# Mods/songsが存在する場合、MODが読み込まれる。
	if DirAccess.dir_exists_absolute("Mods/songs"):
		print("MOD MODE-------------------------")
		load_assets_song = false
	else:
		print("ORIGINAL MODE-------------------------")
		load_assets_song = true
		
	load_masterdata()

# ゲームのマスターデータを読む
func load_masterdata():
	if not load_assets_song:
		week_path_list = ["Mods/weeks"]
		song_path_list = ["Mods/songs/"]
		if FileAccess.file_exists("Mods/data/difficulty.json"):
			var json = File.f_read("Mods/data/difficulty.json", ".json")
			Game.difficulty = json.difficulty
			Game.difficulty_color.clear()
			for diffColor in json.color:
				Game.difficulty_color.append(Color8(int(diffColor[0]), int(diffColor[1]), int(diffColor[2])))
			
			Game.diff = int(json.difficulty.size() /2)

func p_offset(path: String):
	return "Assets/Data/Settings and Offsets/" + path

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

	#print("paths song: invalid path")
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
		for ind in modchart_extensions:
			for index in modchart_filenames:
				var p = i
				if diff == "normal":
					if FileAccess.file_exists(p + path + "/" + index + ind):
						return p + path + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower() + "/" + index + ind):
						return p + path.to_lower() + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + index + ind):
						return p + path.replace(" ", "-") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + index + ind):
						return p + path.to_lower().replace(" ", "-") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + index + ind):
						return p + path.replace("-", " ") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + index + ind):
						return p + path.to_lower().replace("-", " ") + "/" + index + ind
						
				else:
					if FileAccess.file_exists(p + path + "/" + index + "-" + diff + ind):
						return p + path + "/" + index + "-" + diff + ind
						
					elif FileAccess.file_exists(p + path.to_lower() + "/" + index + "-" + diff + ind):
						return p + path.to_lower() + "/" + index + "-" + diff + ind
						
					elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + index + "-" + diff + ind):
						return p + path.replace(" ", "-") + "/" + index + "-" + diff + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + index + "-" + diff + ind):
						return p + path.to_lower().replace(" ", "-") + "/" + index + "-" + diff + ind
						
					elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + index + "-" + diff + ind):
						return p + path.replace("-", " ") + "/" + index + "-" + diff + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + index + "-" + diff + ind):
						return p + path.to_lower().replace("-", " ") + "/" + index + "-" + diff + ind
					
					elif FileAccess.file_exists(p + path + "/" + index + ind):
						return p + path + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower() + "/" + index + ind):
						return p + path.to_lower() + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.replace(" ", "-") + "/" + index + ind):
						return p + path.replace(" ", "-") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace(" ", "-") + "/" + index + ind):
						return p + path.to_lower().replace(" ", "-") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.replace("-", " ") + "/" + index + ind):
						return p + path.replace("-", " ") + "/" + index + ind
						
					elif FileAccess.file_exists(p + path.to_lower().replace("-", " ") + "/" + index + ind):
						return p + path.to_lower().replace("-", " ") + "/" + index + ind
				
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
	for i in week_image_path_list:
		var p = i
		if path == "tutorial":
			return p + "week0.png"
		else:
			if FileAccess.file_exists(p + path.to_lower().replace(" ", "") + ".png"):
				return p + path.to_lower().replace(" ", "") + ".png"
	Audio.a_play("Error")
	printerr("paths week image: invalid path")
	return missing

func p_stage_img(path: String):
	for i in stage_image_path_list:
		if FileAccess.file_exists(i + path + ".png"):
			return Game.load_image(i + path + ".png")
		elif FileAccess.file_exists(i + path.to_lower() + ".png"):
			return Game.load_image(i + path.to_lower() + ".png")
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

func p_stage_script(path: String):
	for i in stage_data_path_list:
		for ext in modchart_extensions:
			if FileAccess.file_exists(i + path + ext):
				return i + path + ext
			elif FileAccess.file_exists(i + path.to_lower() + ext):
				return i + path.to_lower() + ext
	Audio.a_play("Error")
	printerr("paths stage script: invalid path")
	return null

func p_icon(path: String):
	var icon: Texture2D
	for i in icon_path_list:
		var p = i
		if FileAccess.file_exists(p + path + ".png"):
			icon = Game.load_image(p + path + ".png")
			return icon
		elif FileAccess.file_exists(p + "icon-" + path + ".png"):
			icon = Game.load_image(p + "icon-" + path + ".png")
			return icon
		elif FileAccess.file_exists(p + path + "-icons.png"):
			icon = Game.load_image(p + path + "-icons.png")
			return icon
	printerr("icon: icon not found")
	icon = Game.load_image("Assets/Images/Icons/icon-face.png")
	return icon

func p_icon_credits(path: String):
	var icon: Texture2D
	for i in icon_credits_path_list:
		var p = i
		if FileAccess.file_exists(p + path + ".png"):
			icon = Game.load_image(p + path + ".png")
			return icon
		elif FileAccess.file_exists(p + "icon-" + path + ".png"):
			icon = Game.load_image(p + "icon-" + path + ".png")
			return icon
		elif FileAccess.file_exists(p + path + "-icons.png"):
			icon = Game.load_image(p + path + "-icons.png")
			return icon
	printerr("icon: icon not found")
	icon = Game.load_image("Assets/Images/Icons/icon-face.png")
	return icon

func p_image(path: String, xml = false):
	for i in images_path_list:
		if FileAccess.file_exists(i + path + ".png"):
			if xml and FileAccess.file_exists(i + path + ".xml"):
				return i + path + ".xml"
			return i + path + ".png"
	print("path image: image not found")
	return null

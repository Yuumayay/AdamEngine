extends Node

var missing = "Assets/Images/UI/Missing.png"

var song_path_list: Array = ["Assets/Songs/", "Mods/songs/"]
var chart_path_list: Array = ["Assets/Songs/", "Mods/songs/", "Assets/Data/Song Charts/", "Mods/data/song charts/", "Mods/data/", "Mods/data/song data/"]
var icon_path_list: Array = ["Assets/Images/Icons/", "Mods/images/icons/"]
var icon_credits_path_list: Array = ["Assets/Images/Other Icons/Credits/", "Mods/images/other icons/credits/", "Mods/images/credits/"]
var icon_awards_path_list: Array = ["Assets/Images/Other Icons/Awards/", "Mods/images/other icons/awards/", "Mods/images/awards/"]
var week_path_list: Array = ["Assets/Weeks/", "Mods/weeks/"]
var week_image_path_list: Array = ["Assets/Images/Story Mode/Weeks/", "Mods/Images/Story Mode/Weeks/", "mods/images/storymenu/"]
var character_data_path_list: Array = ["Assets/Data/characters/", "Mods/data/characters/", "Mods/characters/"]
var character_image_path_list: Array = ["Assets/Images/characters/", "Mods/images/characters/"]
var stage_data_path_list: Array = ["Assets/Data/Stages/", "Mods/data/stages/", "Mods/stages/"]
var stage_image_path_list: Array = ["Assets/Images/Stages/", "Mods/images/stages/", "Mods/images/"]
var images_path_list: Array = ["Assets/Images/", "Mods/images/"]
var sound_path_list: Array = ["mods/sounds/"]

var modchart_extensions: Array = [".gd"]
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
		#if FileAccess.file_exists("Mods/data/difficulty.json"):
		#	var json = File.f_read("Mods/data/difficulty.json", ".json")
		#	Game.difficulty = json.difficulty
		#	Game.difficulty_color.clear()
		#	for diffColor in json.color:
		#		Game.difficulty_color.append(Color8(int(diffColor[0]), int(diffColor[1]), int(diffColor[2])))
		#	
		#	# diffculty の　半分
		#	Game.diff = clamp(int(floor((json.difficulty.size()-1.0) /2.0)),0, json.difficulty.size()-1)

func p_offset(path: String):
	return "Assets/Data/Settings and Offsets/" + path

func files_template_check(path, path2, diff = "", ext=""):
	var difftext = ""
		
	if diff == "normal" or diff == "": # ノーマル
		difftext = ""
	else:
		difftext = "-"+diff 
		
	var lists = [
		path + "/" + path2 + diff + ext,
		path.replace(" ", "-") + "/" + path2 + difftext + ext,
		path.replace("-", " ") + "/" + path2 + difftext + ext,
	]	
	return files_check(lists)
	
func files_check(paths):
	for i in paths:
		if FileAccess.file_exists(i):
			return i
	return ""
	
func p_song(path: String, path2: String):
	var exist_path : String
	
	for i in song_path_list:
		var p = i
		
		var lists = [
			p + path + "/" + path2 + ".ogg",
			p + path.replace(" ", "-") + "/" + path2 + ".ogg",
			p + path.replace("-", " ") + "/" + path2 + ".ogg",
		]
		
		exist_path = files_check(lists)
		if exist_path != "":
			return exist_path
	
	var lists = [
		path + "/" + path2 + ".ogg",
		path.replace(" ", "-") + "/" + path2 + ".ogg",
		path.replace("-", " ") + "/" + path2 + ".ogg",
	]		
	exist_path = files_check(lists)
	if exist_path != "":
		return exist_path	
	
	#print("paths song: invalid path")
	return null

func p_chart(path: String, diff: String):
	var exist_path : String
	
	for i in chart_path_list:
		var p = i
		var difftext = ""
		
		exist_path = files_template_check(p + path, path, diff, ".json")

		if exist_path != "":
			return exist_path

	exist_path = Game.DEFAULT_SONG
	Audio.a_play("Error")
	printerr("paths chart: invalid path: ", path, diff)
	return exist_path

func p_modchart(path: String, diff: String):
	for i in chart_path_list:
		for ext in modchart_extensions:
			for index in modchart_filenames:
				var p = i
				if FileAccess.file_exists(path + index + ext):
					return path + index + ext
				if FileAccess.file_exists(p + path + "/" + index + ext):
					return p + path + "/" + index + ext
				
				var exist_path = files_template_check(p + path, index, diff, ext)
				if exist_path != "":
					return exist_path
				
	print("paths modchart: no modchart")
	return null

func p_sound(path: String):
	for i in sound_path_list:
		if FileAccess.file_exists(i + path + ".ogg"):
			return i + path + ".ogg"
		elif FileAccess.file_exists(i + path.to_lower() + ".ogg"):
			return i + path.to_lower() + ".ogg"
	Audio.a_play("Error")
	printerr("paths sound: invalid path: ")
	return null

func p_chara(path: String):
	for i in character_data_path_list:
		if FileAccess.file_exists(i + path + ".json"):
			return i + path + ".json"
		elif FileAccess.file_exists(i + path.to_lower() + ".json"):
			return i + path.to_lower() + ".json"
	Audio.a_play("Error")
	printerr("paths character_data: invalid path: ", path)
	return null

func p_chara_xml(path: String):
	if path.contains("characters/"): path = path.replace("characters/", "")
	for i in character_image_path_list:
		if FileAccess.file_exists(i + path + ".xml"):
			return i + path + ".xml"
		elif FileAccess.file_exists(i + path.to_lower() + ".xml"):
			return i + path.to_lower() + ".xml"
	print("paths character_xml: invalid path: ", path)
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
	printerr("paths week image: invalid path: ", path)
	return missing

func p_stage_img(path: String):
	for i in stage_image_path_list:
		if FileAccess.file_exists(i + path + ".png"):
			return Game.load_image(i + path + ".png")
		elif FileAccess.file_exists(i + path.to_lower() + ".png"):
			return Game.load_image(i + path.to_lower() + ".png")
	Audio.a_play("Error")
	printerr("paths stage image: invalid path: ", path)
	return missing

func p_stage_data(path: String):
	for i in stage_data_path_list:
		if FileAccess.file_exists(i + path + ".json"):
			return i + path + ".json"
		elif FileAccess.file_exists(i + path.to_lower() + ".json"):
			return i + path.to_lower() + ".json"
	Audio.a_play("Error")
	printerr("paths stage data: invalid path: ", path)
	return null

func p_stage_script(path: String):
	for i in stage_data_path_list:
		for ext in modchart_extensions:
			if FileAccess.file_exists(i + path + ext):
				return i + path + ext
			elif FileAccess.file_exists(i + path.to_lower() + ext):
				return i + path.to_lower() + ext
	Audio.a_play("Error")
	printerr("paths stage script: invalid path: ", path)
	return null

var diff_image_path_list := ["Assets/Images/Story Mode/Difficulties/", "Mods/Images/Story Mode/Difficulties/", "mods/images/menudifficulties/"]

func p_diff(path: String):
	for i in diff_image_path_list:
		if FileAccess.file_exists(i + path.to_lower() + ".png"):
			return i + path.to_lower() + ".png"
	print("paths get diff path: invalid difficulty name")
	return missing

func p_get_icon_path(path: String, icon: String):
	if FileAccess.file_exists(path + icon + ".png"):
		return path + icon + ".png"
	if FileAccess.file_exists(path + "icon-" + icon + ".png"):
		return path + "icon-" + icon + ".png"
	if FileAccess.file_exists(path + icon + "-icons.png"):
		return path + icon + "-icons.png"
	print("paths get icon path: invalid icon name")
	return "Assets/images/icons/icon-none.png"

func p_icon(path: String):
	var icon: Texture2D
	if FileAccess.file_exists(path):
		icon = Game.load_image(path)
		return icon
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
	print("icon: icon not found")
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
	printerr("icon: icon not found: ", path)
	icon = Game.load_image("Assets/Images/Icons/icon-face.png")
	return icon

func p_icon_awards(path: String):
	var icon: Texture2D
	for i in icon_awards_path_list:
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
	printerr("icon: icon not found: ", path)
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

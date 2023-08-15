extends Node

const SUPPORTED_FORMATS: Array = [".json", ".txt", ".gd"]

func f_save(savepath: String, type: String, content):
	if SUPPORTED_FORMATS.has(type):
		print("savepath: ", savepath, ", type: ", type)
	else:
		printerr("this format is not supported")
	var file
	var filepath = savepath + type
	file = FileAccess.open(filepath, FileAccess.WRITE)
	
	#if type == ".lua":
		#var lua = LuaAPI.new()
		#var luacontent
		#if content is String:
			#luacontent = lua
		#else:
	if type == ".json":
		var jsoncontent
		if content is String:
			jsoncontent = JSON.parse_string(content)
			jsoncontent = JSON.stringify(jsoncontent, "\t", false)
		else:
			jsoncontent = JSON.stringify(content, "\t", false)
		file.store_string(jsoncontent)
	elif type == ".txt" or type == ".gd":
		var txtcontent
		txtcontent = str(content)
		file.store_string(txtcontent)
	file.close()

func f_read(path: String, type: String):
	var file
	var filepath = path
	var data
	print("load path:", filepath)
	file = FileAccess.open(filepath, FileAccess.READ)
	if type == ".json":
		var content = file.get_as_text()
		content = JSON.parse_string(content)
		data = content
	else:
		var content = file.get_as_text()
		data = content
	file.close()
	return data

var conv_lua = [
	["local function", "func"],
	["function", "func"],
	["local", "var"],
	[" then", ":"],
	["elseif", "elif"],
	["else", "else:"],
	["for", "for i in range(1): #"],
	["..", "+"],
	["--", "#"],
	["math.pi", "PI"],
	["onCreate()", "onCreate():"],
	["goodNoteHit()", "goodNoteHit():"],
	["noteMiss()", "noteMiss():"],
	["onUpdate()", "onUpdate():"],
	["onBeatHit()", "onBeatHit():"],
	["onStepHit()", "onStepHit():"],
	["opponentNoteHit()", "opponentNoteHit():"],
	["onSongStart()", "onSongStart():"],
	["makeLuaSprite", "Modchart.makeLuaSprite"],
	["addLuaSprite", "Modchart.addLuaSprite"],
	["makeGraphic", "Modchart.makeGraphic"],
	["setObjectCamera", "Modchart.setObjectCamera"],
	["setObjectOrder", "Modchart.setObjectOrder"],
	["setProperty", "Modchart.setProperty"],
	["getProperty", "Modchart.getProperty"],
	
	["math.", ""],
	["end", ""]
]

func lua_2_gd(content: String):
	for i in conv_lua:
		if content.contains(i[0]):
			content = content.replace(i[0], i[1])
		
	content = content.insert(0, "extends Node\n")
	print(content)
	return content

func _ready():
	lua_2_gd(f_read("res://Mods/stages/hjoim.lua", ".lua"))
	if FileAccess.file_exists("user://ae_options_data.json"):
		#f_save("user://ae_options_data", ".json", Setting.setting)
		Setting.setting = f_read("user://ae_options_data.json", ".json")
	else:
		f_save("user://ae_options_data", ".json", Setting.setting)
	
	if not FileAccess.file_exists("user://ae_score_data.json"):
		File.f_save("user://ae_score_data", ".json", {"song": []})
	
	if not FileAccess.file_exists("user://ae_week_score_data.json"):
		File.f_save("user://ae_week_score_data", ".json", {"week": []})
	
	Setting.setting_refresh()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("end")
		f_save("user://ae_options_data", ".json", Setting.setting)

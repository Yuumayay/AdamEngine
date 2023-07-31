extends Node

const SUPPORTED_FORMATS: Array = [".json", ".txt"]

func f_save(savepath: String, type: String, content):
	if SUPPORTED_FORMATS.has(type):
		print("savepath: ", savepath, ", type: ", type, ", content: ", content)
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
	elif type == ".txt":
		var txtcontent
		txtcontent = str(content)
		file.store_string(txtcontent)
	file.close()

func f_read(path: String, type: String):
	var file
	var filepath = path
	var data
	file = FileAccess.open(filepath, FileAccess.READ)
	if type == ".json":
		var content = file.get_as_text()
		content = JSON.parse_string(content)
		data = content
	elif type == ".txt":
		var content = file.get_as_text()
		data = content
	file.close()
	return data

func _ready():
	if FileAccess.file_exists("user://ae_options_data.json"):
		Setting.setting = f_read("user://ae_options_data.json", ".json")
	else:
		f_save("user://ae_options_data", ".json", Setting.setting)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("end")
		f_save("user://ae_options_data", ".json", Setting.setting)

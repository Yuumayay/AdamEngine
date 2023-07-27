extends Node

func p_offset(path: String):
	return "res://Assets/Data/Settings and Offsets/" + path

func p_song(path: String):
	return "res://Assets/Songs/" + path + ".ogg"

func p_chart(path: String, diff: String):
	return "res://Assets/Data/Song Charts/" + path + "/" + path + "-" + diff + ".json"

func p_chara(path: String):
	return "res://Assets/Data/characters/" + path + ".json"

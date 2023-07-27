extends Label

var ja_font = preload("res://Assets/Fonts/BugMaru.ttc")

func _ready():
	if Game.language == "Japanese":
		add_theme_font_override("font", ja_font)
		add_theme_font_size_override("font_size", 25)

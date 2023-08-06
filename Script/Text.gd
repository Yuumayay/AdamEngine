extends Label

var ja_font 

func _ready():
	ja_font = load("Assets/Fonts/BugMaru.ttc")
	if Game.language == "Japanese":
		add_theme_font_override("font", ja_font)
		add_theme_font_size_override("font_size", 25)

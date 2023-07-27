extends Label

func _ready():
	text = View.version_text
	set("theme_override_colors/font_color", View.version_text_color)

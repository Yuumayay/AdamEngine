extends Node2D

@onready var introtext = $"UI/Intro Text"
@onready var logo = $Logo
@onready var enter = $Logo/Enter

var ind: int = 0
var index: int = 0
var intro_end: bool = false
var rand_end: bool = false

var intro_offset = File.f_read(Paths.p_offset("Title Menu/Intro.json"), ".json")
var texts: Array = intro_offset.introtext.texts
var time: Array = intro_offset.introtext.time

var intro_text_data = File.f_read("res://Assets/Data/introText" + Game.language + ".txt", ".txt")
var intro_texts: PackedStringArray = intro_text_data.split("\n")

var random: int = randi_range(0, intro_texts.size() - 1)
var intro_text: PackedStringArray = intro_texts[random].split("--")

var music_offset = File.f_read(Paths.p_offset("Music/Offset.json"), ".json")
var menu_music_path = "res://Assets/Music/" + music_offset.MenuMusic[0]
var menu_music_bpm = music_offset.MenuMusic[1]

var debug_music_path = "res://Assets/Music/" + music_offset.DebugMusic[0]
var debug_music_bpm = music_offset.DebugMusic[1]

var pause_music_path = "res://Assets/Music/" + music_offset.PauseMusic[0]
var pause_music_bpm = music_offset.PauseMusic[1]

var option_music_path = "res://Assets/Music/" + music_offset.OptionMusic[0]
var option_music_bpm = music_offset.OptionMusic[1]

func _ready():
	print()
	#print(intro_text)
	
	#discord_sdk.app_id = 1133432665505280140
	#discord_sdk.state = "In Title"
	#discord_sdk.large_image = "adam"
	#discord_sdk.large_image_text = "Try it now!"
	#discord_sdk.refresh() 
	
	if Audio.a_check("Freaky Menu"):
		introend()
	else:
		Audio.a_set("Freaky Menu", menu_music_path, menu_music_bpm, true)
		Audio.a_set("Debug Menu", debug_music_path, debug_music_bpm, true)
		Audio.a_set("Pause Menu", pause_music_path, pause_music_bpm, true)
		Audio.a_set("Option Menu", option_music_path, option_music_bpm, true)
		Audio.a_title()
	
	if intro_text.size() == 2:
		texts[9] = "<random>"
	elif intro_text.size() == 3:
		texts[8] = "<random>"
		texts[9] = "<random>"

func introend():
	introtext.text = ""
	logo.visible = true
	Flash.flash(Color("FFFFFF", 0), 3)
	intro_end = true
	
	#GF sprite
	var spr = Game.load_XMLSprite("res://Assets/Images/Title Menu/gfDanceTitle.xml", "", true, 24)
	$Logo/gfpos.add_child(spr)
	

func _process(_delta):
	var beat = Audio.a_get_beat("Freaky Menu", 8)
	
	if Input.is_action_just_pressed("ui_accept") and Game.can_input:
		if not intro_end:
			introend()
		else:
			Audio.a_accept()
			enter.accepted()
			
	if beat == time[ind] and not intro_end:
		if texts[ind] == "<erase>":
			introtext.text = ""
			ind += 1
		elif texts[ind] == "<end>":
			introend()
		elif texts[ind] == "<random>":
			if index == 0:
				introtext.text += intro_text[index]
				index += 1
				ind += 1
			else:
				introtext.text += "\n" + intro_text[index]
				index += 1
				ind += 1
		else:
			introtext.text += texts[ind]
			ind += 1

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

var intro_text_data = File.f_read("Assets/Data/introText" + Game.language + ".txt", ".txt")
var intro_texts: PackedStringArray = intro_text_data.split("\n")

var random: int = randi_range(0, intro_texts.size() - 1)
var intro_text: PackedStringArray = intro_texts[random].split("--")

func _ready():
	#print(intro_text)
	
	#discord_sdk.app_id = 1133432665505280140
	#discord_sdk.state = "In Title"
	#discord_sdk.large_image = "adam"
	#discord_sdk.large_image_text = "Try it now!"
	#discord_sdk.refresh() 
	
	Game.game_mode = Game.TITLE
	Game.edit_jsonpath = ""
		
	if Audio.a_check("Freaky Menu"):
		introend()
	else:
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
	var spr = Game.load_XMLSprite("Assets/Images/Title Menu/gfDanceTitle.xml", "", true, 24)
	spr.name = "GF"
	$Logo/gfpos.add_child(spr)

var beat_gf = 0

func _process(_delta):
	var beat = Audio.a_get_beat("Freaky Menu", 8)
	
	if Input.is_action_just_pressed("ui_accept") and Game.can_input:
		if not intro_end:
			introend()
		else:
			Audio.a_accept()
			enter.accepted()
	
	if intro_end:
		if beat_gf != Audio.a_get_beat("Freaky Menu", 4):
			beat_gf = Audio.a_get_beat("Freaky Menu", 4)
			$Logo/gfpos/GF.frame = int(beat_gf) % 2 * 15
	else:
		if beat == time[ind]:
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

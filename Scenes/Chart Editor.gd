extends Node2D

@onready var template_rect: ColorRect = $Rect
@onready var beat: Line2D = $Beat
@onready var cam = $Camera
@onready var icons = $Icons
@onready var notes = $Notes
@onready var mass = $Mass

@onready var menu = $Menu
@onready var songname = $Menu/SongName
@onready var bpm_label = $Menu/BPM
@onready var speed = $Menu/Speed
@onready var bfname = $Menu/bf
@onready var dadname = $Menu/dad
@onready var reloadaudio = $Menu/ReloadAudio
@onready var savejson = $Menu/SaveJSON
@onready var savejsonwindow: FileDialog = $Menu/SaveJSONWindow
@onready var loadjson = $Menu/LoadJSON
@onready var loadjsonwindow: FileDialog = $Menu/LoadJSONWindow
@onready var gridandzoom = $Menu/GridAndZoom
@onready var song_diff = $Menu/SongDiff

@onready var note_pr = Game.load_XMLSprite("Assets/Images/Notes/Default/default.xml")
var note_tscn = preload("res://Scenes/ChartEditor/chart_note.tscn")
var tex_mass = preload("res://Scenes/ChartEditor/texture_mass.tscn")

var iconScript = preload("res://Script/CharterIcon.gd")

var empty_section = {"sectionBeats":4,"mustHitSection":false,"sectionNotes":[]}

## CONSTS ##
const MASS_SIZE = 50.0
const ONE_SECTION_H = 800.0
const SHIFT_BOOST = 4
const CAM_ZOOM_VALUE = 0.05
const SCREEN_CENTER_X = 640
const SCREEN_CENTER_Y = 360
const MASS_OFFSET_X = 100
const MASS_OFFSET_Y = MASS_SIZE * 5
const BEAT_LINE_QUANTITY = 8
enum {MS, DIR, SUS, NOTE_TYPE, UID}

var chartData: Dictionary = {"notes": [{"sectionBeats":4,"mustHitSection":false,"sectionNotes":[]}],
"song": "Test", "bpm": 150, "player1": "bf", "player2": "dad", "speed": 1.0}

# {"notes": [{"lengthInSteps":16,"mustHitSection":false,"sectionNotes":[]}]}

var modcharts: Dictionary = {
	"category": {
		"gameplay": {
			"HealthDrain": {
				"tooltip": "Placeholder"
			},
			"HealthGain": {
				"tooltip": "Placeholder"
			},
			"NoHealthGain": {
				"tooltip": "Placeholder"
			},
			"NoHealthDrain": {
				"tooltip": "Placeholder"
			}
		},
		"effect": {
			"WavyBG": {
				"tooltip": "Placeholder"
			},
			"RainbowEyesore": {
				"tooltip": "Placeholder"
			},
			"Shockwave": {
				"tooltip": "Placeholder"
			},
			"Distortion": {
				"tooltip": "Placeholder"
			},
			"Glitch": {
				"tooltip": "Placeholder"
			},
			"Flash": {
				"tooltip": "Placeholder"
			},
			"Darkness": {
				"tooltip": "Placeholder"
			},
			"Glow": {
				"tooltip": "Placeholder"
			}
		},
		"ui": {
			"ScreenShake": {
				"tooltip": "Placeholder"
			},
			"ShowImage": {
				"tooltip": "Placeholder"
			},
			"HideImage": {
				"tooltip": "Placeholder"
			},
			"ToggleTrail": {
				"tooltip": "Placeholder"
			},
			"ChangeStage": {
				"tooltip": "Placeholder"
			},
			"ChangeNoteSkin": {
				"tooltip": "Placeholder"
			},
			"ChangeUISkin": {
				"tooltip": "Placeholder"
			},
			"ChangeFont": {
				"tooltip": "Placeholder"
			},
			"ChangeTextColor": {
				"tooltip": "Placeholder"
			},
			"Flash": {
				"tooltip": "Placeholder"
			},
			"ShowPopup": {
				"tooltip": "Placeholder"
			},
			"Lyrics": {
				"tooltip": "Placeholder"
			},
			"ApplyShader": {
				"tooltip": "Placeholder"
			}
		},
		"camera": {
			"CameraBump": {
				"tooltip": "Placeholder"
			},
			"PlayCameraBump": {
				"tooltip": "Placeholder"
			},
			"StopCameraBump": {
				"tooltip": "Placeholder"
			},
			"MoveCamera2D": {
				"tooltip": "Placeholder"
			},
			"MoveCamera3D": {
				"tooltip": "Placeholder"
			},
			"ZoomCamera": {
				"tooltip": "Placeholder"
			},
			"RotateCamera2D": {
				"tooltip": "Placeholder"
			},
			"RotateCamera3D": {
				"tooltip": "Placeholder"
			}
		},
		"property": {
			"ScrollSpeed": {
				"tooltip": "Placeholder"
			},
			"Character": {
				"tooltip": "Placeholder"
			},
			"HealthIcon": {
				"tooltip": "Placeholder"
			},
			"BPM": {
				"tooltip": "Placeholder"
			},
			"GhostTapping": {
				"tooltip": "Placeholder"
			},
			"ScrollDirection": {
				"tooltip": "Placeholder"
			},
			"Practice": {
				"tooltip": "Placeholder"
			},
			"Botplay": {
				"tooltip": "Placeholder"
			},
			"FlipPosition": {
				"tooltip": "Placeholder"
			},
			"Keybind": {
				"tooltip": "Placeholder"
			},
			"KeyCount": {
				"tooltip": "Placeholder"
			},
			"HealthLoss": {
				"tooltip": "Placeholder"
			},
			"HealthGain": {
				"tooltip": "Placeholder"
			},
			"Poison": {
				"tooltip": "Placeholder"
			},
			"Freeze": {
				"tooltip": "Placeholder"
			},
			"Flip": {
				"tooltip": "Placeholder"
			},
			"GhostNotes": {
				"tooltip": "Placeholder"
			}
		},
		"misc": {
			"ChangeProperty": {
				"tooltip": "Placeholder"
			}
		}
	}
}

var menu_dict: Dictionary = {
	"Charting": {
		"Metronome": {
			"type": "bool",
			"cur": false
		},
		"Autoscroll": {
			"type": "bool",
			"cur": true
		},
		"m": {
			"type": "margin",
			"cur": 0
		},
		"BPM": {
			"type": "range",
			"cur": 150.0,
			"range": [0.1, 99999.0],
			"step": 0.1
		},
		"Offset": {
			"type": "range",
			"cur": 0.0,
			"range": [-1000.0, 1000.0],
			"step": 0.1,
			"suffix": "ms"
		},
		"m2": {
			"type": "margin",
			"cur": 10
		},
		"Inst Wave": {
			"type": "bool",
			"cur": false
		},
		"Voices Wave": {
			"type": "bool",
			"cur": false
		},
		"m3": {
			"type": "margin",
			"cur": 0
		},
		"Ignore Warning": {
			"type": "bool",
			"cur": false
		},
		"Auto Save": {
			"type": "bool",
			"cur": true
		},
		"m4": {
			"type": "margin",
			"cur": 0
		},
		"Playback Rate": {
			"type": "range",
			"cur": 1.0,
			"range": [0.1, 3.0],
			"step": 0.1,
			"suffix": "x"
		},
		"Mouse Scroll Speed": {
			"type": "range",
			"cur": 1.0,
			"range": [0.1, 3.0],
			"step": 0.1,
			"suffix": "x"
		},
		"m5": {
			"type": "margin",
			"cur": 0
		},
		"Show Strums": {
			"type": "bool",
			"cur": false
		},
		"m6": {
			"type": "margin",
			"cur": 0
		},
		"Inst Volume": {
			"type": "range",
			"cur": 60.0,
			"range": [0.0, 100.0],
			"step": 0.1,
			"suffix": "%"
		},
		"Voices Volume": {
			"type": "range",
			"cur": 100.0,
			"range": [0.0, 100.0],
			"step": 0.1,
			"suffix": "%"
		}
	},
	"Events": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Modchart": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Note": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Options": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Section": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Song": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	}
}

class ChartData:
	var icon_name := "bf"
	var key_count := 4
	var note_skin = "default" # 未実装
	var modchart = [] #未実装
	var texture_mass 

var data :Array = [ChartData.new(), ChartData.new(), ChartData.new(), ChartData.new(), ChartData.new()]

enum {EVENT, BF, DAD, GF, SECTION_INFO}
const TYPE_LABEL = ["EVENT", "PLAYER", "OPPONENT", "GF", "SECTION_INFO"]
const TYPE_ICON = ["face", "bf", "dad", "gf"]

var bpm: float = 150
var metronome_bpm: float = 150
var multi: float = 1
var mouse_scroll_speed: float = 1

@export var playing: bool = false

var cur_song: String
var cur_diff: String
var songSpeed := 1.0

# ？
var cur_x: float
var cur_y: float #スクロール位置
		
var cur_zoom: float = 1.0


# 現在セクション　（全体スクロール位置で自動決定される
var cur_section: int = 0#:
#	set(v):
#		cur_section = v
#		
#	get:
#		cur_section = int(cur_y / ONE_SECTION_H)
#		return cur_section

## SETTINGS ##
var metronome: bool = false
var hit_sound: int = 0
@export var grid := 1.0
var no_grid := false
var chart_zoom := 1.0
var fileName : String
var loadPath : String
var songPath: String
var jsonPathChara := ["","",""]
var jsonChara := [{},{},{}]
var iconPath := ["","",""]
var charaImagePath := ["","",""]
var jsonStage := {}
var noteXML := ""
var cur_stage := "stage"
var loadAudioByDifficulty := false

# チャートエディタの現在位置　→　秒数にコンバートする
func position_to_time():
	return pos_to_time(cur_y)

# チャートエディタの位置	→　秒数にコンバート
func pos_to_time(y):
	var ret :float = 60.0 / (bpm * chart_zoom) * (y * 2.0 / 1600.0) * 4
	if ret <= 0.0:
		return 0.0
	return ret

func time_to_position(time):
	var ret: float = (60.0 / bpm / time) * 1000 * MASS_SIZE
	return ret


func _ready():
	data[BF].key_count = 4
	data[DAD].key_count = 4
	data[GF].key_count = 4
	Audio.a_volume_set("Debug Menu", -80)
	#for i in range(80):
	#	Audio.a_volume_set("Debug Menu", -i)
	#	await get_tree().create_timer(0.001).timeout
	reloadaudio.pressed.connect(reloadAudio)
	savejsonwindow.set_filters(PackedStringArray(["*.json ; FNF chart data files"]))
	loadjsonwindow.set_filters(PackedStringArray(["*.json ; FNF chart data files"]))
	savejson.pressed.connect(func():
		savejsonwindow.show()
		)
	loadjson.pressed.connect(func():
		loadjsonwindow.show()
		)
	
	songname.text_changed.connect(songname_changed)
	bpm_label.value_changed.connect(bpm_changed)
	speed.value_changed.connect(speed_changed)
	bfname.text_changed.connect(bfname_changed)
	dadname.text_changed.connect(dadname_changed)

	
	if Game.game_mode == Game.FREEPLAY: # フリープレイから来た
		print("CHART FROM FREE PLAY")
		var jsonpath = Paths.p_chart(Game.cur_song, Game.cur_diff)
		var json = File.f_read(jsonpath, ".json")
		loadJson(json)
		Game.game_mode = Game.TITLE
	elif Game.edit_jsonpath != "": #何かしらエディットしている
		if Game.cur_song_data_path:
			print("LOAD FROM ANOTHER MOD FILE")
			
			_on_load_json_window_file_selected(Game.cur_song_data_path + ".json")
		else:
			print("LOAD FROM TEMPFILE")
			
			var json = File.f_read(Game.edit_jsonpath, ".json")
			loadJson(json)
	init()


func init():
	data[EVENT].icon_name = TYPE_ICON[EVENT]
	data[EVENT].key_count = 1
	
	data[DAD].icon_name = TYPE_ICON[DAD]
	data[GF].icon_name = TYPE_ICON[GF]
	
	data[SECTION_INFO].icon_name = TYPE_ICON[EVENT]
	data[SECTION_INFO].key_count = 1
	
	set_key_count_all()
	
	$Menu/Line.position.y = MASS_OFFSET_Y
	var song = get_difficulty_and_songname(fileName)[0]
	var diff = get_difficulty_and_songname(fileName)[1]
	if song is Array:
		var convSong : String
		for i in song:
			if i == song[-1]:
				convSong += i
			else:
				convSong += i + "-"
		song = convSong
	print(diff)
	cur_diff = diff
	song_diff.text = diff
	print(cur_song)
	if not Paths.p_song(cur_song, "Inst"):
		#loadFromAnotherFile(loadPath)
		loadFromAnotherFile_Old(song)
	if !cur_song:
		Audio.a_set("Voices", "Assets/Songs/test/Voices.ogg", bpm)
		Audio.a_set("Inst", "Assets/Songs/test/Inst.ogg", bpm)
		cur_song = "test"
	elif Paths.p_song(cur_song, "Inst"):
		if Paths.p_song(cur_song, "Voices"):
			Audio.a_set("Voices", Paths.p_song(cur_song, "Voices"), bpm)
		else:
			Audio.a_set("Voices", "", bpm)
		Audio.a_set("Inst", Paths.p_song(cur_song, "Inst"), bpm)
	elif Paths.p_song(songPath, "Inst"):
		if Paths.p_song(songPath, "Voices"):
			Audio.a_set("Voices", Paths.p_song(songPath, "Voices"), bpm)
		else:
			Audio.a_set("Voices", "", bpm)
		Audio.a_set("Inst", Paths.p_song(songPath, "Inst"), bpm)
	
	erase_all_notes()
	set_all_notes()
	draw_menu()
	draw_all()
	
	for i in $Menu.get_children():
		if i is LineEdit:
			i.connect("mouse_entered", _on_button_mouse_entered)
			i.connect("mouse_exited", _on_button_mouse_exited)
			

func loadFromAnotherFile_Old(song):
		#MOD（psych, adam)のアイコン、キャラクターの読み込み
		songPath = ""
		var dataFilePaths := ["data/" + song + "/" + fileName,
		"songs/" + song + "/" + fileName,
		"data/songs/" + song + "/" + fileName,
		"data/song data/" + song + "/" + fileName,
		"data/song charts/" + song + "/" + fileName,
		"data/charts/" + fileName]
		for i in dataFilePaths:
			#loadFromAnotherFile(loadPath)
			print(i + song)
			print(loadPath.replacen(i, "songs/" + song), " conv ", fileName)
			songPath = loadPath.replacen(i, "songs/" + song)
			var songData := {"song": {"player1": "bf", "player2": "dad", "player3": "gf"}}
			if FileAccess.file_exists(loadPath + ".json"):
				songData = File.f_read(loadPath + ".json", ".json")
			var gf_name = Game.get_gf_name(songData)
			if songData.song.has("stage"):
				cur_stage = songData.song.stage
				if Paths.p_stage_data(cur_stage):
					jsonStage = File.f_read(Paths.p_stage_data(cur_stage), ".json")
				else:
					var stagePath = songPath.replacen("songs/" + song, "stages/")
					if FileAccess.file_exists(stagePath.replacen("assets/", "mods/") + cur_stage + ".json"):
						jsonStage = File.f_read(stagePath.replacen("assets/", "mods/") + cur_stage + ".json", ".json")
					elif FileAccess.file_exists(stagePath.replacen("mods/", "assets/") + cur_stage + ".json"):
						jsonStage = File.f_read(stagePath.replacen("mods/", "assets/") + cur_stage + ".json", ".json")
			else:
				cur_stage = "stage"
				jsonStage = File.f_read(Paths.p_stage_data("stage"), ".json")
			for j in range(3):
				var folder = songPath.replacen("songs/" + song, "")
				if j == 2:
					if gf_name == "none":
						jsonPathChara[j] = Paths.p_chara(gf_name)
					else:
						jsonPathChara[j] = songPath.replacen("songs/" + song, "characters/" + songData.song[gf_name] + ".json")
				else:
					jsonPathChara[j] = songPath.replacen("songs/" + song, "characters/" + songData.song["player" + str(j + 1)] + ".json")
				if !FileAccess.file_exists(jsonPathChara[j]):
					jsonPathChara[j] = jsonPathChara[j].replacen("mods/", "assets/")
				if !FileAccess.file_exists(jsonPathChara[j]):
					folder = folder.replacen(fileName, "")
					folder = folder.replacen("/data/song data/" + song, "")
					if FileAccess.file_exists(songPath.replacen("songs/" + song, "shared/images/ui skins/default/arrows/default.xml")):
						noteXML = songPath.replacen("songs/" + song, "shared/images/ui skins/default/arrows/default.xml")
					jsonPathChara[j] = jsonPathChara[j].replacen("assets/", "mods/")
					jsonPathChara[j] = jsonPathChara[j].replacen("characters/" + songData.song["player" + str(j + 1)] + ".json", "character data/" + songData.song["player" + str(j + 1)] + "/config.json")
				if song and FileAccess.file_exists(jsonPathChara[j]):
					print("!!")
					jsonChara[j] = File.f_read(jsonPathChara[j], ".json")
					iconPath[j] = Paths.p_get_icon_path(songPath.replacen("songs/" + song, "images/icons/"), jsonChara[j].healthicon.to_lower())
					if not iconPath[j]:
						iconPath[j] = "bf"
					data[j].icon_name = jsonChara[j].healthicon.to_lower()
					for cPath in DirAccess.get_directories_at(folder):
						if cPath == "shared":
							if FileAccess.file_exists(folder + cPath + "/images/" + jsonChara[j].image + ".png"):
								charaImagePath[j] = folder + cPath + "/images/" + jsonChara[j].image + ".png"
								break
						else:
							if FileAccess.file_exists(folder + cPath + "/" + jsonChara[j].image + ".png"):
								charaImagePath[j] = folder + cPath + "/" + jsonChara[j].image + ".png"
								break
					var modfolder = folder.replacen("assets/", "mods/")
					for cPath in DirAccess.get_directories_at(modfolder):
						if cPath == "shared":
							if FileAccess.file_exists(modfolder + cPath + "/images/" + jsonChara[j].image + ".png"):
								charaImagePath[j] = modfolder + cPath + "/images/" + jsonChara[j].image + ".png"
								break
						else:
							if FileAccess.file_exists(modfolder + cPath + "/" + jsonChara[j].image + ".png"):
								charaImagePath[j] = modfolder + cPath + "/" + jsonChara[j].image + ".png"
								break
			if FileAccess.file_exists(songPath + "/Inst.ogg"):
				cur_song = song
				break

var assetsPresets := ["assets", "mods"]
var dataPresets := ["data", "song charts", "song data", "charts", "chart data"]

func loadFromAnotherFile(loadPath):
	print(loadPath.split("/"))
	var engineType = "unknown"
	var sp = loadPath.split("/")
	var songName = sp[-1].split("-")[0]
	var songNameDiff = sp[-1]
	for assets in assetsPresets:
		for data in dataPresets:
			var songDir = ["/" + assets + "/" + data + "/" + songName + "/" + songNameDiff,
			"/" + assets + "/" + data + "/" + songName]
			var dir_i := 0
			for dir in songDir:
				var rep = loadPath.replacen(dir, "")
				var fullpath = rep + dir + ".json"
				print(fullpath)
				if dir_i == 0 and FileAccess.file_exists(fullpath):
					print("pe or ke or le: ", dir)
					engineType = "psych"
					return
				elif dir_i == 1 and FileAccess.file_exists(fullpath):
					print("dave: ", dir)
					engineType = "dave"
					return
				dir_i += 1

func draw_menu():
	pass

func draw_all():
	var total_x := 0
	var space := MASS_SIZE
	
	# remove all child
	for i in mass.get_children():
		mass.remove_child(i)
		i.queue_free()
	
	# append empty section
	if cur_section >= chartData.notes.size()-2:
		for i in cur_section - (chartData.notes.size() - 2):
			chartData.notes.append(empty_section.duplicate(true))
	
	var offset_y = cur_section * ONE_SECTION_H * chart_zoom
	
	# event mass
	var type = EVENT #massの種類
	var keycount = 1
	
	# BF DAD　GF mass
	for j in range(0, 5):
		type = j
		keycount = data[j].key_count
		# 合計xを50増やして空白を開ける
		total_x += space
		if cur_section != 0:
			draw_mass_texture(total_x, MASS_OFFSET_Y - ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * keycount, MASS_SIZE * 16 * chart_zoom, 0.5, type, cur_section -1)
		data[type].texture_mass = draw_mass_texture(total_x, MASS_OFFSET_Y + offset_y, MASS_SIZE * keycount, MASS_SIZE * 16 * chart_zoom, 1.0, type, cur_section)
		draw_mass_texture(total_x, MASS_OFFSET_Y + ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * keycount, MASS_SIZE * 16 * chart_zoom, 0.5, type, cur_section + 1)
		# 合計xを(マスサイズ * キー数)ずつ増やす
		total_x += (MASS_SIZE * keycount)
		
		# icon追加
		draw_icon(data[type].texture_mass.position.x + (MASS_SIZE * data[type].key_count / 2.0) - MASS_SIZE, data[type].icon_name, type)

	# beat line
	draw_beat_line(BEAT_LINE_QUANTITY, cur_section * 4)
	
	redraw_sectioninfo()
	

func draw_mass(og_x, og_y, column, row, _alpha, type, _section, player, p_ind):
	var index = 0
	var x = og_x
	var y = og_y
	for i in column:
		index += 1
		y = og_y
		x += 50
		for ind in row:
			y += 50
			var new_rect = template_rect.duplicate()
			new_rect.position = Vector2(x, y + (cur_section * (50 * 16)))
			if index % 2 == 0:
				new_rect.color = Color(0.5, 0.5, 0.5)
			else:
				new_rect.color = Color(0.55, 0.55, 0.55)
			new_rect.visible = true
			if ind >= 16:
				new_rect.modulate.a = 0.5
			new_rect.note_type = type
			new_rect.dir = i
			new_rect.ms = ind + (cur_section * 16)
			new_rect.player_type = player
			new_rect.player_ind = p_ind
			mass.add_child(new_rect)
			index += 1

func draw_mass_texture(x, y, w, h, a, type, sec_id):
	var mass_texture = tex_mass.instantiate()
	mass_texture.position.x = x
	mass_texture.position.y = y
	mass_texture.size.x = w
	mass_texture.size.y = h
	mass_texture.modulate.a = a
	mass_texture.show()
	mass_texture.type = type
	mass_texture.section = sec_id
	mass.add_child(mass_texture)
	return mass_texture

# (honsuu)個のラインをstart_line_nからLINEを生成する
func draw_beat_line(honsuu, start_line_n):
	for i in honsuu:
		var new_beat = beat.duplicate()
		new_beat.visible = true
		new_beat.get_node("Label").text = str(i + start_line_n)
		new_beat.position.y = (i + start_line_n) * (MASS_SIZE * 4 * chart_zoom) + MASS_OFFSET_Y
		mass.add_child(new_beat)

# アイコン再描画。　既にあれば生成しない。
func draw_icon(x, icon_name, p_type : int ):
	var objname = "icon-"+str(p_type)
	
	var new_icon = icons.get_node_or_null(objname)
	var new_f = false
	if !new_icon:
		new_f = true
		new_icon = Sprite2D.new()
		new_icon.set_script(iconScript)
		new_icon.name = objname
	if p_type != SECTION_INFO and p_type != EVENT:
		if iconPath[p_type - 1] != "" and FileAccess.file_exists(iconPath[p_type - 1]):
			new_icon.texture = Game.load_image(iconPath[p_type - 1])
		else:
			print(icon_name)
			new_icon.texture = Paths.p_icon(icon_name)
	else:
		new_icon.texture = Paths.p_icon("face")

	new_icon.position.x = x + 50
	new_icon.position.y = 50
	new_icon.hframes = floor(new_icon.texture.get_width() / 150.0)
	new_icon.scale = Vector2(0.5, 0.5)
	
	new_icon.icon_name = icon_name
	
	new_icon.key_count = data[p_type].key_count
	new_icon.p_type = p_type
	
	if new_f:
		new_icon.init()
		#icons.add_child.call_deferred(new_icon)
		icons.add_child(new_icon)

func erase_all_notes():
	for i in notes.get_children():
		notes.remove_child(i)
		i.queue_free()


func set_key_count_all():
	var ret = Game.get_json_keycount(chartData)
	data[BF].key_count = ret[0]
	data[DAD].key_count = ret[1]
	data[GF].key_count = ret[2]
	
	draw_all()
#	for j in range(1, 4):
#		chartData["player" + str(j) + "KeyCount"] = value
#		data[j].key_count = value
#	draw_all()

func set_all_notes():
	for section in chartData.notes:
		for i in section["sectionNotes"]:
			var ms = i[0]
			var dir: int = i[1]

			var type: int = DAD
			
			if dir >= data[BF].key_count+ data[DAD].key_count:
				type = GF
				dir -= data[BF].key_count+ data[DAD].key_count
				
			elif section.mustHitSection:
				type = BF
				if dir >= data[BF].key_count:
					type = DAD
					dir -= data[BF].key_count
			
			else:
				type = DAD
				if dir >= data[DAD].key_count:
					type = BF
					dir -= data[DAD].key_count
			
			var sus = i[2]
			
			if !sus is String:
				if sus <= 0.0:
					sus = 0
			
			var note = set_note_line_ms(type, ms, sus, dir, data[type].key_count)
			if i.size() == 3:
				i.append(0)
			if i.size() == 4:
				i.append(-1)
			i[4] = note.uid
				
func set_note_line_ms(type, ms, susms, dir, keycount):
	var y = ms_to_y(ms)
	var x = data[type].texture_mass.position.x + dir * MASS_SIZE
	var susy = susms_to_y(susms)
	
	return set_note_and_line(x, y, susy, dir, keycount)

# ノート生成
func set_note_and_line(noteX, noteY, lineY, dir: int, keycount):
	var note_parent = note_tscn.instantiate()
	var note = note_parent.get_node("sprite")
	note.sprite_frames = note_pr.sprite_frames
	note_parent.position = Vector2(noteX, noteY)
	note.centered = false
	note.scale = Vector2(0.3, 0.3)
	if keycount > 18:
		note.animation = View.keys["18k"][dir % 18]
	else:
		note.animation = View.keys[str(keycount) + "k"][dir % 18]
	note.position += Vector2(2, 2)
	note.z_index = 2
	notes.add_child(note_parent)
	
	var line = note_parent.line
	line.add_point(Vector2.ZERO, 0)
	line.add_point(Vector2(0, lineY), 1)
	line.position = Vector2(MASS_SIZE/2,MASS_SIZE/2)
	return note_parent

func set_character(type, value):
	data[type].icon_name = value
	draw_all()

func set_key_count(type, value):
	chartData["player" + str(type) + "KeyCount"] = value
	data[type].key_count = value
	print(chartData["player" + str(type) + "KeyCount"])
	draw_all()

func set_note_skin(type, value):
	pass

func _process(_delta):
	# カメラのx座標を(画面中央x+現在のx)にする
	cam.position.x = SCREEN_CENTER_X + cur_x
	# カメラのy座標を(画面中央y+現在のy)にする
	cam.position.y = SCREEN_CENTER_Y + cur_y
	# カメラのズームを現在のズームに合わせる
	cam.zoom = Vector2(cur_zoom, cur_zoom)
	
	# キー入力をチェック
	key_check()
	
	# スクロールをチェック
	scroll()
	
	# ノーツ配置をチェック
	#note_check()
	
	# 設定をチェック(仮)

var ind2: int = 0

func scroll():
	## 音楽が再生中のとき ##
	if playing:
		# 現在のyを現在のビート(float)をMASS_SIZE * 4でかけたものにする
		cur_y = Audio.a_get_beat_float("Inst") * (MASS_SIZE * 4) * chart_zoom
		
		## メトロノーム処理 ##
		# ビートが変わったら
		if ind2 != Audio.a_get_beat("Inst"):
			ind2 = Audio.a_get_beat("Inst")
			
			## メトロノームがオンなら ##
			if metronome:
				# 拍子が1拍目だったらTickを再生
				if ind2 % 4 == 0:
					Audio.a_play("Tick")
				
				# それ以外だったらTockを再生
				else:
					Audio.a_play("Tock")
	
	## マウスホイール上が押されたとき ##
	if Input.is_action_just_pressed("game_scroll_up"):
		# 音楽が再生中だったら止める
		stop_audio()
		
		# Shiftが押されていたら4倍の速度で移動
		if Input.is_action_pressed("game_shift"):
			cur_y -= MASS_SIZE * mouse_scroll_speed * SHIFT_BOOST
		
		# Ctrlが押されていたら横移動する
		elif Input.is_action_pressed("game_ctrl"):
			cur_x += MASS_SIZE * mouse_scroll_speed
		
		# Altが押されていたらカメラをズームイン
		elif Input.is_action_pressed("game_alt"):
			cur_zoom += 0.05
		
		# それ以外(単純にマウスホイール上だけ)のときは等倍速で移動
		else:
			cur_y -= MASS_SIZE * mouse_scroll_speed
	
	## マウスホイール下が押されたとき ##
	if Input.is_action_just_pressed("game_scroll_down"):
		# 音楽が再生中だったら止める
		stop_audio()
		
		# Shiftが押されていたら4倍の速度で移動
		if Input.is_action_pressed("game_shift"):
			cur_y += MASS_SIZE * mouse_scroll_speed * SHIFT_BOOST
		
		# Ctrlが押されていたら横移動する
		elif Input.is_action_pressed("game_ctrl"):
			cur_x -= MASS_SIZE * mouse_scroll_speed
		
		# Altが押されていたらカメラをズームアウト
		elif Input.is_action_pressed("game_alt"):
			cur_zoom -= CAM_ZOOM_VALUE
		
		# それ以外(単純にマウスホイール下だけ)のときは等倍速で移動
		else:
			cur_y += MASS_SIZE * mouse_scroll_speed
	
	## セクション移動処理 ##
	# 現在のyが(１セクションの縦の長さ*セクション数)より小さくなったら
	if cur_y < ONE_SECTION_H * cur_section * chart_zoom:
		# セクション数が0以外のときだけセクションを-1してdraw_allで更新
		if cur_section != 0:
			cur_section -= 1
			draw_all()
	# 現在のyが１セクションの縦の長さ+(１セクションの縦の長さ*セクション数)より大きくなったら
	if cur_y > ONE_SECTION_H * chart_zoom + (ONE_SECTION_H * chart_zoom * cur_section):
		# セクションを+1してdraw_allで更新
		cur_section += 1
		draw_all()

var lastBPM := 150.0

func songname_changed(new_text):
	print("song name change")
	chartData["song"] = new_text

func bpm_changed(value):
	bpm = value
	chartData["bpm"] = value

func speed_changed(value):
	chartData["speed"] = value

func bfname_changed(new_text):
	data[BF].icon_name = new_text
	chartData["player1"] = new_text

func dadname_changed(new_text):
	data[DAD].icon_name = new_text
	chartData["player2"] = new_text

func reloadAudio():
	var difftext: String
	if loadAudioByDifficulty:
		difftext = "-"+cur_diff
	var inst = "Inst" + difftext
	var voices = "Voices" + difftext
	if !Paths.p_song(songname.text, inst):
		if !Paths.p_song(songPath, inst):
			Audio.a_play("Error")
			printerr(inst + ".ogg not found")
			return
		else:
			if Paths.p_song(songPath, voices):
				Audio.a_set("Voices", Paths.p_song(songPath, voices), bpm)
			Audio.a_set("Inst", Paths.p_song(songPath, inst), bpm)
			cur_song = songname.text
	if Paths.p_song(songname.text, voices):
		Audio.a_set("Voices", Paths.p_song(songname.text, voices), bpm)
	Audio.a_set("Inst", Paths.p_song(songname.text, inst), bpm)
	cur_song = songname.text

func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false
	
func generateJson() -> Dictionary:
	var json: Dictionary = {"song": chartData}
	var section_n := 0
	var sectionNotes_n := 0
	var jsonNotes = json["song"]["notes"]
	for section in chartData.notes:
		section.sectionNotes.sort_custom(sort_ascending) #整列
		for i in section.sectionNotes:
			#if note.player_type == 0: # EVENT kuso イベントはイベントでループする TODO
			#	jsonNotes[section_n]["sectionNotes"].append([note.ms, note.dir - 1, note.sus, note.note_type ])
			i.erase(UID)
			sectionNotes_n += 1
		section_n += 1
		
	return json

func loadJson(json):
	var song = json.song
	
	bpm_label.value = song.bpm
	speed.value = song.speed
	songname.text = song.song
	bfname.text = song.player1
	dadname.text = song.player2
	bpm = song.bpm
	cur_song = song.song
	
	for j in range(1, 4):
		if j == BF:
			data[j].icon_name = song.player1
		elif j == DAD:
			data[j].icon_name = song.player2
		elif j == GF:
			if song.has("gfVersion"):
				data[j].icon_name = song.gfVersion
			else:
				data[j].icon_name = "gf"
		
		data[j].note_skin = "default" # kuso
		data[j].modchart = [] # kuso
	
	songSpeed = song.speed
	
	chartData = json.song
	
	init()


func get_difficulty_and_songname(text : String):
	var sp: Array = text.split("-")
	var dif = sp[-1].to_lower()
	print(sp, ", ", dif.to_lower())
	if Game.difficulty_color.has(dif.to_lower()):
		sp.erase(sp[-1])
		return [sp, dif.to_lower()]
	
	return [text, "normal"]

func key_check():
	if Input.is_action_just_pressed("ui_cancel"):
		stop_audio()
		Audio.a_stop("Debug Menu")
		Audio.a_volume_set("Debug Menu", 0)
		Trans.t_trans("Debug Menu")
	
	if !shortCut:
		return
	
	if Input.is_action_just_pressed("game_pause"):
		stop_audio()
		Audio.a_stop("Debug Menu")
		Audio.a_volume_set("Debug Menu", 0)
		var diffandfile = get_difficulty_and_songname(cur_song)
		Game.cur_song = diffandfile[0]
		Game.cur_diff = cur_diff
		Audio.bpm = bpm
		if !Paths.p_song(Game.cur_song, "Inst"):
			Game.cur_song_path = songPath
			Game.cur_song_data_path = loadPath
			Game.chara_image_path = charaImagePath
			Game.chara_json = jsonChara
			Game.stage_json = jsonStage
			Game.cur_stage = cur_stage
			Game.iconBF = iconPath[0]
			Game.iconDAD = iconPath[1]
			Game.noteXML = noteXML
		Game.edit_jsonpath = "user://ae_chart_temp" + ".json"
		File.f_save("user://ae_chart_temp", ".json", generateJson())
		Trans.t_trans("Gameplay")
	if Input.is_action_just_pressed("game_space"):
		if playing:
			stop_audio()
		else:
			playing = true
			Audio.a_play("Inst", multi, 0.0, position_to_time())
			Audio.a_play("Voices", multi, 0.0, position_to_time())
	if Input.is_action_just_pressed("game_editor_prev"): 
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			cur_y -= 800 * 4 * chart_zoom
		else:
			cur_y -= 800 * chart_zoom
	if Input.is_action_just_pressed("game_editor_next"):
		stop_audio()
		if Input.is_action_pressed("game_shift"):
			cur_y += 800 * 4 * chart_zoom
		else:
			cur_y += 800 * chart_zoom
	if Input.is_action_pressed("game_shift"):
		no_grid = true
	else:
		no_grid = false
	if Input.is_action_just_pressed("chart_grid_up"):
		grid *= 2
		grid_text_set()
	if Input.is_action_just_pressed("chart_grid_down"):
		grid /= 2
		grid_text_set()
	if Input.is_action_just_pressed("chart_zoom_up"):
		cur_y = cur_y * 2 
		chart_zoom *= 2
		grid_text_set()
		draw_all()
		updateZoom()
		
	if Input.is_action_just_pressed("chart_zoom_down"):
		cur_y = cur_y / 2
		chart_zoom /= 2
		grid_text_set()
		draw_all()
		updateZoom()

func grid_text_set():
	gridandzoom.text = "Zoom: " + str(chart_zoom) + "x\nGrid: 1/" + str(16 / grid)

# グリッド この関数でX,Yグリッドセット
func fix_grid(x, grid = 1.0):
	return floor( x / (MASS_SIZE * grid)) * (MASS_SIZE * grid)

# グリッド この関数でX,Yマス目番号変換
func get_grid(x):
	return floor( x / MASS_SIZE ) 

func stop_audio():
	playing = false
	Audio.a_stop("Inst")
	Audio.a_stop("Voices")

func deleteNote(uid):
	for sec in chartData.notes:
		for i in sec.sectionNotes:
			if i[UID] == uid:
				sec.sectionNotes.erase(i)
				return

func updateZoom():
	for sec in chartData.notes:
		for i in sec.sectionNotes:
			var uid = i[UID]
			var n =notes.get_node(str(uid))
			n.position.y = ms_to_y(i[MS]) 
			
			var line :Line2D = n.line
			if (not i[SUS] is String) and (i[SUS] == 0):
				line.hide()
			else:
				line.set_point_position(1, Vector2(0, susms_to_y(i[SUS])  + MASS_SIZE/2) )
				line.show()


# FNFのキモいデータ形式fnfdirへ変換
func calc_fnfdir(mustHit, type, dir):
	if (type == DAD and mustHit):
		dir += data[BF].key_count
	elif (type == BF and !mustHit):
		dir += data[DAD].key_count
	elif (type == GF):
		dir += data[BF].key_count + data[DAD].key_count
	return dir

# TODO keycount変更時にchartDataが更新されてないぞ

# FNFのキモいデータ形式fnfdirをtypeとdirに分解
func rev_type_fnfdir(mustHit, dir):
	var type = 0
	if mustHit:
		type = BF #mustHitはdir0からがBF側
	else:
		type = DAD #mustHitはdir0からがBF側
	
	if (dir >= data[BF].key_count + data[DAD].key_count):
		dir -= data[BF].key_count + data[DAD].key_count
		type = GF
	elif (mustHit and dir >= data[BF].key_count): #BF側で、DAD
		dir -= data[BF].key_count
		type = DAD
	elif (!mustHit and dir >= data[DAD].key_count): #DAD側で、BF
		dir -= data[DAD].key_count
		type = BF
	# TODO GF
		
	return type

func rev_dir_fnfdir(mustHit, dir):
	var type = 0
	if mustHit:
		type = BF #mustHitはdir0からがBF側
	else:
		type = DAD #mustHitはdir0からがBF側
		
	if (dir >= data[BF].key_count + data[DAD].key_count):
		dir -= data[BF].key_count + data[DAD].key_count
		type = GF
	elif (mustHit and dir >= data[BF].key_count): #BF側で、DAD
		dir -= data[BF].key_count
		type = DAD
	elif (!mustHit and dir >= data[DAD].key_count): #DAD側で、BF
		dir -= data[DAD].key_count
		type = BF
	# TODO GF
	
	return dir

# ノートを置く
func on_mouse_down_set_note( texturemass ):
	var t = texturemass.type
	if t != SECTION_INFO:
		# ms　へのコンバート
		var i = texturemass
		var type = i.type
	
		var x = fix_grid(get_local_mouse_position().x)
		var dir = (x - i.position.x)  / MASS_SIZE
		if dir >= data[type].key_count: #範囲外から押される（決定ボタンでこのイベントが送られたパターン
			return 
		var mustHit = chartData.notes[cur_section].mustHitSection
		
		var y = fix_grid(get_local_mouse_position().y, grid)
		
		print(x, y)
		Audio.a_play("Place")
		var sus := 0
		var distance := 0.0
		var key = data[type].key_count
		# ボタンとラインおく
		var note = set_note_and_line(x, y, sus, dir, key)
		var sec_id = texturemass.section
		
		if type != EVENT:
			var line = note.line
			while Input.is_action_pressed("game_click"):
				distance = (floor(((y - get_local_mouse_position().y) ) / MASS_SIZE)+1) * -MASS_SIZE
				if not line:
					break
				if not note:
					return
				if distance <= 0:
					sus = 0
					line.set_point_position(1, Vector2(0, sus))
				else:
					sus = distance
					line.set_point_position(1, Vector2(0, sus + MASS_SIZE/2))
				await get_tree().create_timer(0).timeout
		
		var ms = y_to_ms(y) 
		var susms = susy_to_ms(sus)
		
		chartData.notes[sec_id]["sectionNotes"].append([ms, calc_fnfdir(mustHit, t, dir), susms, 0, note.uid])
		print(chartData.notes[sec_id]["sectionNotes"][-1])
		
		updateZoom()
	else:
		# section iconの場合、何もせずリドロー
		redraw_sectioninfo()

# section iconの生成と再描画
@onready var Secs = $Secs
var sec_icon_pr = preload("res://Scenes/ChartEditor/sec_icon.tscn")
func redraw_sectioninfo():
	var sec_id := 0
	for sec in chartData.notes:
		for i in range(1): #iconの種類
			var n : Sprite2D = Secs.get_node_or_null(get_secicon_name(sec_id, i))
			if !n:
				n = sec_icon_pr.instantiate()
				n.name = get_secicon_name(sec_id, i)
				n.position.y = MASS_OFFSET_Y + ONE_SECTION_H * sec_id + i*MASS_SIZE
				n.section = sec_id
				n.icontype = i
				Secs.add_child(n)
			n.set_icon()
		
		sec_id += 1

func get_secicon_name(sec_id, icon_id):
	return "s-"+ str(sec_id)+"-"+ str(icon_id)

func y_to_ms(y):
	var ms_per_beat :float = (60.0 / bpm) * 1000.0 / chart_zoom
	var ms_per_step :float = ms_per_beat/4
	
	var step :float = (y - MASS_OFFSET_Y) / MASS_SIZE
	
	return step * ms_per_step
	
func susy_to_ms(y):
	var sus :float = y + MASS_OFFSET_Y
	return y_to_ms(sus)

func susms_to_y(ms):
	if ms is String:
		return 0
	var ms_per_beat :float = (60.0 / bpm) * 1000.0 / chart_zoom
	var ms_per_step :float = ms_per_beat/4
	var step :float = ms / ms_per_step
	var y :float = step * MASS_SIZE
	return y
	
func ms_to_y(ms): # msからyへ
	var ms_per_beat :float = (60.0 / bpm) * 1000.0 / chart_zoom
	var ms_per_step :float = ms_per_beat/4
	
	var step :float = ms / ms_per_step
	var y :float = step * MASS_SIZE
	
	return y + MASS_OFFSET_Y


func _on_save_json_window_file_selected(path):
	var extension = path.get_extension()
	var basename = path.get_basename()
	if extension == "json":
		print(basename, ".", extension)
		File.f_save(basename, "." + extension, generateJson())
		Game.edit_jsonpath = basename+ "." + extension


func _on_load_json_window_file_selected(path):
	var extension = path.get_extension()
	var basename = path.get_basename()
	var file = path.get_file()
	fileName = file.get_basename()
	loadPath = basename
	if extension == "json":
		print(basename, ".", extension)
		var json = File.f_read(path, "." + extension)
		loadJson(json)
		Game.edit_jsonpath = basename+ "." + extension

var shortCut = true
# チャート画面をマウスオーバーしたらショートカットオン
func _on_button_mouse_entered():
	shortCut = false

func _on_button_mouse_exited():
	shortCut = true
	


func _on_load_audio_by_difficulty_toggled(toggled_on):
	loadAudioByDifficulty = toggled_on


func _on_song_diff_text_changed(new_text):
	cur_diff = new_text

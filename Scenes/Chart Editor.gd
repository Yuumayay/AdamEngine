extends Node2D

@onready var template_rect: ColorRect = $Rect
@onready var beat: Line2D = $Beat
@onready var cam = $Camera
@onready var icons = $Icons
@onready var notes = $Notes
@onready var mass = $Mass
@onready var tex_mass = $TextureMass

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

@onready var note_pr = Game.load_XMLSprite("Assets/Images/Notes/Default/default.xml")
var note_tscn = preload("res://Scenes/ChartEditor/chart_note.tscn")

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
const MASS_OFFSET_Y = 250
const BEAT_LINE_QUANTITY = 8


var chartData: Dictionary = {"notes": [{"lengthInSteps":16,"mustHitSection":false,"sectionNotes":[]}]}

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
	var type := 0
	var count: int = 1

var bf : ChartData = ChartData.new()
var dad : ChartData = ChartData.new()
var gf : ChartData = ChartData.new()

var data :Array = [bf, dad, gf]
#var key_count: Array = [[4], [4], [4]]

var bpm: float = 150
var metronome_bpm: float = 150
var multi: float = 1
var mouse_scroll_speed: float = 1

@export var playing: bool = false

var cur_song: String
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

var bf_count: int = 1
var dad_count: int = 1
var gf_count: int = 1

var bf_data: Dictionary = {"icon_name": ["bf"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
var dad_data: Dictionary = {"icon_name": ["dad"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
var gf_data: Dictionary = {"icon_name": ["gf"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}

var massPos: Array

## SETTINGS ##
var metronome: bool = false
var hit_sound: int = 0
@export var grid := 1.0
var no_grid := false
var chart_zoom := 1.0

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
	init()
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

func init():
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
	
	draw_menu()
	draw_all()

func draw_menu():
	pass

func draw_all():
	var total_x := 0
	var space := MASS_SIZE
	var bf_pos: Array = []
	var dad_pos: Array = []
	var gf_pos: Array = []
	var bf_key = bf_data["key_count"]
	var dad_key = dad_data["key_count"]
	var gf_key = gf_data["key_count"]
	
	
	# remove all child
	for i in mass.get_children():
		mass.remove_child(i)
	
	massPos.clear()
	
	# append empty section
	if cur_section >= chartData.notes.size() - 1:
		for i in cur_section - (chartData.notes.size() - 1):
			chartData.notes.append(empty_section.duplicate(true))
	
	var offset_y = cur_section * ONE_SECTION_H * chart_zoom + space
	
	# event mass
	if cur_section != 0:
		draw_mass_texture(MASS_OFFSET_X, MASS_OFFSET_Y - ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE, MASS_SIZE * 16 * chart_zoom, 0.5)
	draw_mass_texture(MASS_OFFSET_X, MASS_OFFSET_Y + offset_y, MASS_SIZE, MASS_SIZE * 16 * chart_zoom)
	draw_mass_texture(MASS_OFFSET_X, MASS_OFFSET_Y + ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE, MASS_SIZE * 16 * chart_zoom, 0.5)
	total_x += MASS_OFFSET_X + space
	massPos.append({"type" = 0, "ind" = 0, "key" = 1, "pos" = total_x})
	
	# bf mass
	for i in bf_count:
		# 合計xを50増やして空白を開ける
		total_x += space
		massPos.append({"type" = 1, "ind" = i, "key" = bf_key[i], "pos" = total_x})
		bf_pos.append(total_x)
		if cur_section != 0:
			draw_mass_texture(total_x, MASS_OFFSET_Y - ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * bf_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		draw_mass_texture(total_x, MASS_OFFSET_Y + offset_y, MASS_SIZE * bf_key[i], MASS_SIZE * 16 * chart_zoom)
		draw_mass_texture(total_x, MASS_OFFSET_Y + ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * bf_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		# 合計xを(マスサイズ * キー数)ずつ増やす
		total_x += (MASS_SIZE * bf_key[i])
	
	# dad mass
	for i in dad_count:
		# 合計xを50増やして空白を開ける
		total_x += space
		massPos.append({"type" = 2, "ind" = i, "key" = dad_key[i], "pos" = total_x})
		dad_pos.append(total_x)
		if cur_section != 0:
			draw_mass_texture(total_x, MASS_OFFSET_Y - ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * dad_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		draw_mass_texture(total_x, MASS_OFFSET_Y + offset_y, MASS_SIZE * dad_key[i], MASS_SIZE * 16 * chart_zoom)
		draw_mass_texture(total_x, MASS_OFFSET_Y + ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * dad_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		# 合計xを(マスサイズ * キー数)ずつ増やす
		total_x += (MASS_SIZE * dad_key[i])
	
	# gf mass
	for i in gf_count:
		# 合計xを50増やして空白を開ける
		total_x += space
		massPos.append({"type" = 3, "ind" = i, "key" = gf_key[i], "pos" = total_x})
		gf_pos.append(total_x)
		if cur_section != 0:
			draw_mass_texture(total_x, MASS_OFFSET_Y - ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * gf_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		draw_mass_texture(total_x, MASS_OFFSET_Y + offset_y, MASS_SIZE * gf_key[i], MASS_SIZE * 16 * chart_zoom)
		draw_mass_texture(total_x, MASS_OFFSET_Y + ONE_SECTION_H * chart_zoom + offset_y, MASS_SIZE * gf_key[i], MASS_SIZE * 16 * chart_zoom, 0.5)
		# 合計xを(マスサイズ * キー数)ずつ増やす
		total_x += (MASS_SIZE * gf_key[i])
	
	# beat line
	# (BEAT_LINE_QUANTITY)個のラインを(現在セクション*4)から生成する
	draw_beat_line(BEAT_LINE_QUANTITY, cur_section * 4)
	
	# event icon
	draw_icon(MASS_SIZE + MASS_SIZE / 2, "face", "EVENT", null)
	
	# bf icon
	for i in bf_count:
		draw_icon(bf_pos[i] + (MASS_SIZE * bf_key[i] / 2.0) - MASS_SIZE, bf_data["icon_name"][i], "PLAYER", i)
	
	# dad icon
	for i in dad_count:
		draw_icon(dad_pos[i] + (MASS_SIZE * dad_key[i] / 2.0) - MASS_SIZE, dad_data["icon_name"][i], "OPPONENT", i)
	
	# gf icon
	for i in gf_count:
		draw_icon(gf_pos[i] + (MASS_SIZE * gf_key[i] / 2.0) - MASS_SIZE, gf_data["icon_name"][i], "GF", i)
	
	#set_notes()

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

func draw_mass_texture(x, y, w, h, a = 1, type = 0, ind = 0):
	var mass_texture = tex_mass.duplicate()
	mass_texture.position.x = x
	mass_texture.position.y = y
	mass_texture.size.x = w
	mass_texture.size.y = h
	mass_texture.modulate.a = a
	mass_texture.show()
	mass.add_child(mass_texture)

func draw_beat_line(value, value2):
	for i in value:
		var new_beat = beat.duplicate()
		new_beat.visible = true
		#new_beat.ind = i + value2
		new_beat.get_node("Label").text = str(i + value2)
		new_beat.position.y = (i + value2) * (MASS_SIZE * 4 * chart_zoom)
		mass.add_child(new_beat)

func draw_icon(x, icon_name, p_type, p_ind):
	for i in icons.get_children():
		icons.remove_child(i)
	var new_icon = Sprite2D.new()
	new_icon.texture = Paths.p_icon(icon_name)
	new_icon.position.x = x + 50
	new_icon.position.y = 50
	new_icon.hframes = floor(new_icon.texture.get_width() / 150.0)
	new_icon.scale = Vector2(0.5, 0.5)
	
	new_icon.set_script(iconScript)
	new_icon.icon_name = icon_name
	new_icon.p_type = p_type
	if p_ind is int:
		new_icon.p_ind = p_ind
	if p_type == "PLAYER":
		new_icon.key_count = bf_data["key_count"][p_ind]
	elif p_type == "OPPONENT":
		new_icon.key_count = dad_data["key_count"][p_ind]
	elif p_type == "GF":
		new_icon.key_count = gf_data["key_count"][p_ind]
	new_icon.init()
	
	icons.add_child.call_deferred(new_icon)

func set_note_and_line_ms(noteX, ms, lineY, dir, key):
	return set_note_and_line(noteX, time_to_position(ms), lineY, dir, key)

# ノート生成
func set_note_and_line(noteX, noteY, lineY, dir, key):
	var note_parent = note_tscn.instantiate()
	var note = note_parent.get_node("sprite")
	note.sprite_frames = note_pr.sprite_frames
	note_parent.position = Vector2(noteX, noteY)
	note.centered = false
	note.scale = Vector2(0.3, 0.3)
	note.animation = View.keys[str(key) + "k"][dir]
	note.position += Vector2(2, 2)
	note.z_index = 2
	
	var line = Line2D.new()
	line.add_point(Vector2.ZERO, 0)
	line.add_point(Vector2(0, lineY), 1)
	line.name = "line"
	line.width = 10
	line.default_color = Color(1, 1, 1)
	line.position = Vector2(MASS_SIZE/2,MASS_SIZE/2)
	notes.add_child(note_parent)
	note_parent.add_child(line)
	return note_parent

func add_character(type):
	if type == "PLAYER":
		bf_count += 1
		bf_data["key_count"].append(4)
		bf_data["icon_name"].append("bf")
	elif type == "OPPONENT":
		dad_count += 1
		dad_data["key_count"].append(4)
		dad_data["icon_name"].append("dad")
	elif type == "GF":
		gf_count += 1
		gf_data["key_count"].append(4)
		gf_data["icon_name"].append("gf")
	draw_all()

func erase_character(type, ind):
	if type == "PLAYER":
		bf_count -= 1
		bf_data["key_count"].erase(bf_data["key_count"][ind])
		bf_data["icon_name"].erase(bf_data["icon_name"][ind])
	elif type == "OPPONENT":
		dad_count -= 1
		dad_data["key_count"].erase(dad_data["key_count"][ind])
		dad_data["icon_name"].erase(dad_data["icon_name"][ind])
	elif type == "GF":
		gf_count -= 1
		gf_data["key_count"].erase(gf_data["key_count"][ind])
		gf_data["icon_name"].erase(gf_data["icon_name"][ind])
	draw_all()

func clone_character(type, icon_name, key_count):
	if type == "PLAYER":
		bf_count += 1
		bf_data["key_count"].append(key_count)
		bf_data["icon_name"].append(icon_name)
	elif type == "OPPONENT":
		dad_count += 1
		dad_data["key_count"].append(key_count)
		dad_data["icon_name"].append(icon_name)
	elif type == "GF":
		gf_count += 1
		gf_data["key_count"].append(key_count)
		gf_data["icon_name"].append(icon_name)
	draw_all()

func set_character(type, ind, value):
	if type == "PLAYER":
		bf_data["icon_name"][ind] = value
	elif type == "OPPONENT":
		dad_data["icon_name"][ind] = value
	elif type == "GF":
		gf_data["icon_name"][ind] = value
	draw_all()

func set_key_count(type, ind, value):
	if type == "PLAYER":
		#if bf_data["key_count"][ind] > value:
		#	var index := 0
		#	for i in placed_notes.notes:
		#		print(i)
		#		if i[0] >= value:
		#			placed_notes.notes.erase(placed_notes.notes[index])
		#		index += 1
		bf_data["key_count"][ind] = value
	elif type == "OPPONENT":
		#if dad_data["key_count"][ind] > value:
		#	var index := 0
		#	for i in placed_notes.notes:
		#		if i[0] >= value:
		#			placed_notes.notes.erase(placed_notes.notes[index])
		#		index += 1
		dad_data["key_count"][ind] = value
	elif type == "GF":
		#if gf_data["key_count"][ind] > value:
		#	var index := 0
		#	for i in placed_notes.notes:
		#		if i[0] >= value:
		#			placed_notes.notes[index].erase()
		#		index += 1
		gf_data["key_count"][ind] = value
	draw_all()

func set_note_skin(type, ind, value):
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
	setting_check_beta()

var ind2: int = 0

func scroll():
	#print(cur_y)
	
	## 音楽が再生中のとき ##
	if playing:
		# 現在のyを現在のビート(float)を200とmultiでかけたものにする (?????)
		cur_y = Audio.a_get_beat_float("Inst") * 200 * multi * chart_zoom
		
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

func setting_check_beta():
	if lastBPM != bpm_label.value:
		lastBPM = bpm_label.value
		bpm = bpm_label.value
	songSpeed = speed.value
	bf_data.icon_name[0] = bfname.text
	dad_data.icon_name[0] = dadname.text

func reloadAudio():
	if !Paths.p_song(songname.text, "Inst"):
		Audio.a_play("Error")
		printerr("Inst.ogg not found")
		return
	if Paths.p_song(songname.text, "Voices"):
		Audio.a_set("Voices", Paths.p_song(songname.text, "Voices"), bpm)
	Audio.a_set("Inst", Paths.p_song(songname.text, "Inst"), bpm)
	cur_song = songname.text

func generateJson() -> Dictionary:
	var json: Dictionary = {"song": {
			"song": cur_song,
			"bpm": bpm,
			"player1": bf_data["icon_name"][0],
			"player2": dad_data["icon_name"][0],
			"gfVersion": "gf", # TODO 変更可能なgf
			"speed": songSpeed,
			"notes": [],
			"engine": "Adam Engine 1.0"
		}
	}
	var section_n := 0
	var sectionNotes_n := 0
	var jsonNotes = json["song"]["notes"]
	for section in chartData.notes:
		jsonNotes.append(empty_section.duplicate(true))
		for note in section.sectionNotes:
			if note.player_type == 0: # EVENT
				jsonNotes[section_n]["sectionNotes"].append([note.ms, note.dir - 1, note.sus, note.note_type, note.player_type, note.player_ind])
			elif note.player_type == 1: # BF
				jsonNotes[section_n]["sectionNotes"].append([note.ms, note.dir + ((note.player_type - 1) * bf_data["key_count"][note.player_ind]), note.sus, note.note_type, note.player_type, note.player_ind])
			elif note.player_type == 2: # DAD
				jsonNotes[section_n]["sectionNotes"].append([note.ms, note.dir + ((note.player_type - 1) * dad_data["key_count"][note.player_ind]), note.sus, note.note_type, note.player_type, note.player_ind])
			elif note.player_type == 3: # GF
				jsonNotes[section_n]["sectionNotes"].append([note.ms, note.dir + ((note.player_type - 1) * gf_data["key_count"][note.player_ind]), note.sus, note.note_type, note.player_type, note.player_ind])
			sectionNotes_n += 1
		section_n += 1
		
	print(json)
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
	bf_count = 1
	dad_count = 1
	gf_count = 1
	bf_data = {"icon_name": [song.player1], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
	dad_data = {"icon_name": [song.player2], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
	if song.has("gfVersion"):
		gf_data = {"icon_name": [song.gfVersion], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
	else:
		gf_data = {"icon_name": ["gf"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
	songSpeed = song.speed
	
	chartData.notes.clear()
	for i in song.notes:
		var data: Dictionary = {}
		if i.has("sectionBeats"):
			data["sectionBeats"] = i.sectionBeats
		else:
			data["sectionBeats"] = 4
		data["mustHitSection"] = i.mustHitSection
		data["sectionNotes"] = []
		for ind in i.sectionNotes:
			var ms = ind[0]
			var dir = int(ind[1]) % 4
			var sus = ind[2]
			var note_type = 0
			var player_type = ind[2] / 4 + 1
			var player_ind = 0
			if ind.size() == 4:
				note_type = ind[3]
			data.sectionNotes.append({"ms" = ms, "dir" = dir, "sus" = sus, "note_type" = note_type, "player_type" = player_type, "player_ind" = player_ind})
	
		chartData.notes.append(data)
	print(chartData)
	init()
	
#func setting_check():
	#if container.get_node("Charting/Flow/Metronome/Margin/Flow/CheckBox").button_pressed:
	#	metronome = true
	#else:
	#	metronome = false
	
	#metronome_bpm = container.get_node("Charting/Flow/BPM/Margin/Flow/SpinBox").value
	#multi = container.get_node("Charting/Flow/Playback Rate/Margin/Flow/SpinBox").value
	#mouse_scroll_speed = container.get_node("Charting/Flow/Mouse Scroll Speed/Margin/Flow/SpinBox").value

func key_check():
	if Input.is_action_just_pressed("ui_cancel"):
		stop_audio()
		Audio.a_stop("Debug Menu")
		Audio.a_volume_set("Debug Menu", 0)
		Trans.t_trans("Debug Menu")
		
	if Input.is_action_just_pressed("game_space"):
		if playing:
			stop_audio()
		else:
			print(position_to_time())
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
		chart_zoom *= 2
		grid_text_set()
		draw_all()
	if Input.is_action_just_pressed("chart_zoom_down"):
		chart_zoom /= 2
		grid_text_set()
		draw_all()

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

# ノートを置く
func on_mouse_down_set_note( texturemass ):
		var x = fix_grid(get_local_mouse_position().x)
		var y = fix_grid(get_local_mouse_position().y, grid)
		
		print(x, y)
		for i in massPos:
			for ind in i.key:
				if i.pos + ind * MASS_SIZE == x:
					var place := true
					for index in chartData.notes[cur_section]["sectionNotes"]:
						if time_to_position(index.ms) == y:
							place = false
					if place:
						Audio.a_play("Place")
						var dir = ind
						var pType = i.type
						var pInd = i.ind
						var sus := 0
						var distance := 0.0
						var key = i.key
						var note = set_note_and_line(x, y, sus, dir, key)
						var line = note.get_node("line")
						while Input.is_action_pressed("game_click"):
							distance = (floor(((y - get_local_mouse_position().y) ) / MASS_SIZE)+1) * -MASS_SIZE
							print(distance)
							if not line:
								return
							if distance <= 0:
								sus = 0
								line.set_point_position(1, Vector2(0, sus))
							else:
								sus = distance
								line.set_point_position(1, Vector2(0, sus + 25))
							await get_tree().create_timer(0).timeout
						# ボタンとラインおく
						# set_note_and_line(x, y, sus, dir, key)
						chartData.notes[cur_section]["sectionNotes"].append({"ms" = y, "dir" = dir, "sus" = sus, "note_type" = 0, "player_type" = pType, "player_ind" = pInd})
						break

# チャートデータを１つで管理。
#  -> チャートデータからノーツを生成

func _on_save_json_window_file_selected(path):
	var extension = path.get_extension()
	var basename = path.get_basename()
	if extension == "json":
		print(basename, ".", extension)
		File.f_save(basename, "." + extension, generateJson())


func _on_load_json_window_file_selected(path):
	var extension = path.get_extension()
	var basename = path.get_basename()
	if extension == "json":
		print(basename, ".", extension)
		var json = File.f_read(path, "." + extension)
		loadJson(json)

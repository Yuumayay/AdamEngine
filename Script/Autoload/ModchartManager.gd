extends Node

var is_modchart: bool = false
var mNode: Node
var gameplay: Node2D
var modLayer: CanvasLayer
var lyricslabel: Label
var ui: CanvasLayer
var info: CanvasLayer

var has_onUpdate: bool = false
var has_onBeatHit: bool = false
var has_onSectionHit: bool = false

var modcharts: Dictionary = {}

# MODCHARTの初期化がされていないので、曲が終わったら初期化するようにする TODO
func loadModchart():
	gameplay = $/root/Gameplay
	modLayer = gameplay.get_node("ModchartCanvas")
	lyricslabel = modLayer.get_node("LyricsLabel")
	ui = gameplay.get_node("UI")
	info = gameplay.get_node("Info")
	if Paths.p_modchart(Game.cur_song, Game.cur_diff): #もしmodchartファイルが存在するなら
		# modchart.gdのonCreate関数を実行
		var scr: Script = load(Paths.p_modchart(Game.cur_song, Game.cur_diff))
		mNode = $/root/Gameplay/ModchartScript
		mNode.set_script(scr)
		
		if mNode.has_method("onCreate"):
			mNode.call("onCreate")
			
		if mNode.has_method("onUpdate"):
			has_onUpdate = true # 初期化されていない
			
		if mNode.has_method("onBeatHit"):
			has_onBeatHit = true # 初期化されていない
			
		if mNode.has_method("onSectionHit"):
			has_onSectionHit = true # 初期化されていない
			
		is_modchart = true # 初期化されていない
	else: #存在しないなら何もしない
		print("no modchart")

func _process(delta):
	if is_modchart:
		if has_onUpdate:
			mNode.call("onUpdate", delta)
		if Audio.beat_hit_event:
			if has_onBeatHit:
				mNode.call("onBeatHit")
		if Audio.section_hit_event:
			if has_onSectionHit:
				mNode.call("onSectionHit")

func mGet(key: String, index = -1):
	if modcharts.has(key):
		if index == -1:
			return modcharts[key]
		else:
			return modcharts[key][index]
	return null

func drawBlackBG():
	var blackBG = ColorRect.new()
	blackBG.set_anchors_preset(Control.PRESET_FULL_RECT)
	blackBG.color = Color(0, 0, 0)
	modLayer.add_child(blackBG)

func drawTextureBG(t: Texture2D, tag: String):
	var textureBG = TextureRect.new()
	textureBG.set_anchors_preset(Control.PRESET_FULL_RECT)
	textureBG.texture = t
	textureBG.name = tag
	modLayer.add_child(textureBG)

func setTextureBG(t: Texture2D, tag: String):
	var textureBG = get_node_or_null("/root/Gameplay/ModchartCanvas/" + tag)
	
	if not textureBG:
		Audio.a_play("Error")
		printerr("TextureBG \"" + tag + "\" does not exist")
		return
	
	textureBG.texture = t

func drawLyrics(value: String, sec = -1, color = Color(1, 1, 1)):
	lyricslabel.text = value
	lyricslabel.add_theme_color_override("font_color", color)
	
	if sec == -1:
		return
	else:
		await get_tree().create_timer(sec).timeout
	
	lyricslabel.text = ""

func eraseDraw(tag: String):
	var target = modLayer.get_node_or_null(tag)
	
	if not target:
		Audio.a_play("Error")
		printerr("\"" + tag + "\" does not exist")
		return
	
	target.queue_free()

func camZoomDad(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.dad.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camZoomBF(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.bf.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camZoomGF(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.gf.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camReset():
	gameplay.get_node("Camera").state = 0

func hideUI():
	ui.hide()
	info.hide()

func showUI():
	ui.show()
	info.show()

func setHealthDrain(damage = 0.05, healthMin = 0.0):
	modcharts["healthDrain"] = [damage, healthMin]

func setMiddleScroll(value = true, hideEnemy = true):
	modcharts["middleScroll"] = [value, hideEnemy]

func setDefeatModchart(missLimit = 1, allowShit = true, counter = true, moveHealthBar = false):
	modcharts["defeat"] = [missLimit, allowShit, counter, moveHealthBar]

func setGhostTapping(value = 0.1, addMiss = true, missAnim = true):
	modcharts["ghostTapping"] = [value, addMiss, missAnim]

# 未実装
func setHealthGain(value = 0.1):
	if value is int: # valueがintだったらすべてのhealthGain量をvalueにする
		modcharts["healthGain"] = [value]
	elif value is Array: # Arrayだったら細かい調整
		modcharts["healthGain"] = value

# 未実装
func setMissDamage(value = 0.1):
	modcharts["missDamage"] = value

# 未実装
func keyToMove(where = "debug", key = "7"):
	modcharts["keyToMove"] = [where, key]

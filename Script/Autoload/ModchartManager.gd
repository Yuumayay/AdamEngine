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

func setHealthDrain(value = 0.05, health_min = 0.0):
	modcharts["healthDrain"] = [value, health_min]

func setMiddleScroll(value = true, hide_enemy = true):
	modcharts["middleScroll"] = [value, hide_enemy]

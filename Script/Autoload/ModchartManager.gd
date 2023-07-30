extends Node

var is_modchart: bool = false
var mNode: Node
var gameplay: Node2D

var has_onUpdate: bool = false
var has_onBeatHit: bool = false
var has_onSectionHit: bool = false

func loadModchart():
	gameplay = $/root/Gameplay
	if Paths.p_modchart(Game.cur_song, Game.cur_diff): #もしmodchartファイルが存在するなら
		# modchart.gdのonCreate関数を実行
		var scr: Script = load(Paths.p_modchart(Game.cur_song, Game.cur_diff))
		mNode = $/root/Gameplay/ModchartScript
		mNode.set_script(scr)
		
		if mNode.has_method("onCreate"):
			mNode.call("onCreate")
			
		if mNode.has_method("onUpdate"):
			has_onUpdate = true
			
		if mNode.has_method("onBeatHit"):
			has_onBeatHit = true
			
		if mNode.has_method("onSectionHit"):
			has_onSectionHit = true
			
		is_modchart = true
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
	var modLayer = get_node_or_null("/root/Gameplay/ModchartCanvas")
	if not modLayer:
		var cLayer = CanvasLayer.new()
		cLayer.name = "ModchartCanvas"
		cLayer.layer = 0
		gameplay.add_child(cLayer)
		modLayer = cLayer
	
	var blackBG = ColorRect.new()
	blackBG.set_anchors_preset(Control.PRESET_FULL_RECT)
	blackBG.color = Color(0, 0, 0)
	modLayer.add_child(blackBG)

func drawTextureBG(t: Texture2D, tag: String):
	var modLayer = get_node_or_null("/root/Gameplay/ModchartCanvas")
	if not modLayer:
		var cLayer = CanvasLayer.new()
		cLayer.name = "ModchartCanvas"
		cLayer.layer = 0
		gameplay.add_child(cLayer)
		modLayer = cLayer
	
	var textureBG = TextureRect.new()
	textureBG.set_anchors_preset(Control.PRESET_FULL_RECT)
	textureBG.texture = t
	textureBG.name = tag
	modLayer.add_child(textureBG)

func setTextureBG(t: Texture2D, tag: String):
	var modLayer = get_node_or_null("/root/Gameplay/ModchartCanvas")
	var textureBG = get_node_or_null("/root/Gameplay/ModchartCanvas/" + tag)
	
	if not modLayer:
		Audio.a_play("Error")
		printerr("modchartLayer does not exist")
		return
	if not textureBG:
		Audio.a_play("Error")
		printerr("TextureBG \"" + tag + "\" does not exist")
		return
	
	textureBG.texture = t

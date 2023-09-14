extends Node

signal modchart_ready

var is_modchart: bool = false
var mNode: Node
var gameplay
var modLayer: CanvasLayer
var lyricslabel: Label
var ui: CanvasLayer
var info: CanvasLayer
var strums: CanvasLayer
var notes: CanvasLayer
var stages
var luasprites
var scoretext

var has_onUpdate: bool = false
var has_onStepHit := false
var has_onBeatHit: bool = false
var has_onSectionHit: bool = false
var has_onDestroy: bool = false
var has_opponentNoteHit := false
var has_goodNoteHit := false

var modcharts: Dictionary = {}

func loadModchart():
	if Game.cur_song.to_lower() == "defeat" or Game.cur_song.to_lower() == "defeated":
		setDefeatModchart()
	gameplay = $/root/Gameplay
	modLayer = gameplay.get_node("ModchartCanvas")
	lyricslabel = modLayer.get_node("LyricsLabel")
	ui = gameplay.get_node("UI")
	info = gameplay.get_node("Info")
	strums = gameplay.get_node("Strums")
	notes = gameplay.get_node("Notes")
	stages = gameplay.get_node("Stages")
	luasprites = gameplay.get_node("LuaSprites")
	scoretext = info.get_node("ScoreTxt/Label1")
	var modchartPath
	if Paths.p_modchart(Game.cur_song, Game.cur_diff):
		modchartPath = Paths.p_modchart(Game.cur_song, Game.cur_diff)
	else:
		print(Game.cur_song + "-" + Game.cur_diff)
		print(Game.cur_song_data_path.replacen(Game.cur_song + "-" + Game.cur_diff, ""))
		modchartPath = Paths.p_modchart(Game.cur_song_data_path.replacen(Game.cur_song + "-" + Game.cur_diff, ""), Game.cur_diff)
	if modchartPath: #もしmodchartファイルが存在するなら
		# modchart.gdのonCreate関数を実行
		
		# TODO lua対応
		#if modchartPath.get_extension() == "lua":
			#File.f_save("user://ae_modchart_temp", ".gd", File.lua_2_gd(File.f_read(modchartPath, ".lua")))
			#modchartPath = "user://ae_modchart_temp" + ".gd"
		
		var scr: Script = load(modchartPath)
		mNode = $/root/Gameplay/ModchartScript
		mNode.set_script(scr)
		
		if mNode.has_method("onCreate"):
			mNode.call("onCreate")
		
		if mNode.has_method("onCreatePost"):
			mNode.call("onCreatePost")
			
		if mNode.has_method("onUpdate"):
			has_onUpdate = true
		
		if mNode.has_method("onStepHit"):
			has_onStepHit = true
		
		if mNode.has_method("onBeatHit"):
			has_onBeatHit = true
			
		if mNode.has_method("onSectionHit"):
			has_onSectionHit = true
		
		if mNode.has_method("onDestroy"):
			has_onDestroy = true
		
		if mNode.has_method("goodNoteHit"):
			has_goodNoteHit = true
		
		if mNode.has_method("opponentNoteHit"):
			has_opponentNoteHit = true
			
		is_modchart = true
	else: #存在しないなら何もしない
		print("no modchart")
	
	emit_signal("modchart_ready")

func _process(delta):
	if is_modchart:
		if has_onUpdate and not Game.trans and not Game.cur_state == Game.PAUSE:
			mNode.call("onUpdate")
		if Audio.step_hit_event:
			if has_onStepHit:
				mNode.call("onStepHit")
		if Audio.beat_hit_event:
			if has_onBeatHit:
				mNode.call("onBeatHit")
		if Audio.section_hit_event:
			if has_onSectionHit:
				mNode.call("onSectionHit")
		if Game.cur_state == Game.NOT_PLAYING:
			if has_onDestroy:
				mNode.call("onDestroy")
			reset()

func reset():
	is_modchart = false
	has_onUpdate = false
	has_onStepHit = false
	has_onBeatHit = false
	has_onDestroy = false
	has_onSectionHit = false
	has_goodNoteHit = false
	has_opponentNoteHit = false
	mNode = null

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
	blackBG.name = "blackBG"
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

func hideUI():
	ui.hide()
	info.hide()

func showUI():
	ui.show()
	info.show()

func hideBarAndIcon():
	ui.hide()

func showBarAndIcon():
	ui.show()

func hideInfo():
	info.hide()

func showInfo():
	info.show()

func hideNote():
	strums.hide()
	notes.hide()

func showNote():
	strums.show()
	notes.show()

func setScoreTextColor(value = Color(1, 1, 1)):
	scoretext.add_theme_color_override("font_color", value)

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

func keyToMove(where = "debug", difficulty = "normal", key = "7"):
	modcharts["keyToMove"] = [where, difficulty, key]

func makeLuaSprite(tag: String, path: String, x = 0.0, y = 0.0):
	var spr
	var image_path = Paths.p_image(path, true)
	if image_path:
		if image_path.get_extension() == "xml":
			spr = Game.load_XMLSprite(image_path)
		elif image_path.get_extension() == "png":
			spr = Sprite2D.new()
			spr.texture = Game.load_image(image_path)
		spr.centered = true
	else:
		spr = ColorRect.new()
	spr.position = Vector2(x * -2, y * -2)
	spr.scale = Vector2(1, 1)
	spr.name = tag
	var layer = CanvasLayer.new()
	layer.follow_viewport_enabled = true
	layer.add_child(spr)
	luasprites.add_child(layer)

func makeGraphic(tag, w, h, color):
	var target = luasprites.get_node_or_null(tag)
	if (target) and (target is ColorRect):
		target.get_child(0).size = Vector2(w, h)
		target.get_child(0).color = color

func addLuaSprite(tag: String, front):
	pass

func spawnTitle(sec = 2.0):
	gameplay.get_node("SongTitle").spawnTitle(sec)

func setProperty(key: String, value):
	var sp = key.split(".")
	var target = sp[0]
	var set
	for i in sp.size() - 1:
		if i == sp.size() - 1:
			set += sp[i + 1]
		else:
			set += sp[i + 1] + "/"
	if sp.size() != 0:
		if Game[target]:
			Game[target] = value
		elif luasprites.get_node_or_null(target):
			luasprites.get_node_or_null(target).set(set, value)

func getProperty(key: String):
	var sp = key.split(".")
	var target = sp[0]
	var set
	for i in sp.size() - 1:
		if i == sp.size() - 1:
			set += sp[i + 1]
		else:
			set += sp[i + 1] + "/"
	if sp.size() != 0:
		if Game[target]:
			return Game[target]
		elif luasprites.get_node_or_null(target):
			return luasprites.get_node_or_null(target)[set]

func getSongPosition():
	var inst: AudioStreamPlayer = Audio.get_node("Inst")
	return inst.get_playback_position() * 1000.0

func playSound(path: String):
	var sound = load(Paths.p_sound(path))
	var soundplayer = AudioStreamPlayer.new()
	soundplayer.stream = sound
	soundplayer.play()

############### CAMERA ###############

func setObjectCamera(tag, cam):
	var target = luasprites.get_node_or_null(tag)
	if target:
		if cam == "HUD":
			target.follow_viewport_enabled = false
		elif cam == "other":
			target.follow_viewport_enabled = false
		elif cam == "game":
			target.follow_viewport_enabled = true

func camZoomDad(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.dad.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camZoomBF(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.bf.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camZoomGF(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0, offset = Vector2.ZERO):
	var cam = gameplay.get_node("Camera")
	cam.camMove(cam.gf.getPosOffset() + offset, zoom, sec, cspeed, zspeed)

func camZoomSet(zoom = 1, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0):
	var cam = gameplay.get_node("Camera")
	cam.camMove("same", zoom, sec, cspeed, zspeed)

func camReset():
	gameplay.get_node("Camera").state = 0

func cameraShake(intensity = 10, dulation = 0.1, camera = "camGame"):
	var cam = gameplay.get_node("Camera")
	cam.camShake(intensity, dulation)

func camPosSet(pos = Vector2(0, 0), lock = true):
	var cam = gameplay.get_node("Camera")
	if lock:
		cam.state = 1
	else:
		cam.state = 0
	cam.position = pos

func camPosAdd(pos = Vector2(0, 0), lock = true):
	var cam = gameplay.get_node("Camera")
	if lock:
		cam.state = 1
	else:
		cam.state = 0
	cam.position += pos

func camLock():
	var cam = gameplay.get_node("Camera")
	cam.state = 2

############### SHADER EFFECTS ###############

func glitch(shake_color_rate = 0.001, shake_power = 0.0, shake_rate = 1.0, shake_speed = 0.0, shake_block_size = 30.5):
	gameplay.get_node("Distortion").show()
	var rect: ColorRect = gameplay.get_node("Distortion/Rect")
	rect.material.set("shader_parameter/shake_power", shake_power)
	rect.material.set("shader_parameter/shake_rate", shake_rate)
	rect.material.set("shader_parameter/shake_speed", shake_speed)
	rect.material.set("shader_parameter/shake_block_size", shake_block_size)
	rect.material.set("shader_parameter/shake_color_rate", shake_color_rate)

func impact(force = 0, size = 1, thickness = 1, center = Vector2(0.5, 0.5)):
	gameplay.get_node("Impact").show()
	var rect: ColorRect = gameplay.get_node("Impact/Rect")
	rect.material.set("shader_parameter/center", center)
	rect.material.set("shader_parameter/force", force)
	rect.material.set("shader_parameter/size", size)
	rect.material.set("shader_parameter/thickness", thickness)

############### TWEEN ###############

func doTweenAngle(tag, vars, value = 0.0, dulation = 0.0, ease = "", trans = ""):
	if tag and vars:
		if ease == "":
			ease = Tween.EASE_IN
		if trans == "":
			trans = Tween.TRANS_LINEAR
		var t = create_tween()
		t.set_ease(ease)
		t.set_trans(trans)
		if vars == "iconP1":
			t.tween_property(gameplay.get_node("UI/HealthBarBG/icons/" + vars), "rotation_degrees", value, dulation)
		elif vars == "iconP2":
			t.tween_property(gameplay.get_node("UI/HealthBarBG/icons/" + vars), "rotation_degrees", value, dulation)
		elif vars == "bf":
			t.tween_property(gameplay.get_node("Characters/bfpos/bf"), "rotation_degrees", value, dulation)
		elif vars == "dad":
			t.tween_property(gameplay.get_node("Characters/dadpos/dad"), "rotation_degrees", value, dulation)
		elif vars == "gf":
			t.tween_property(gameplay.get_node("Characters/gfpos/gf"), "rotation_degrees", value, dulation)

func doTweenColor(tag, color, dulation = 1, ea = Tween.EASE_IN, tr = Tween.TRANS_LINEAR):
	if tag and color:
		var target = modLayer.get_node_or_null(tag)
		if target:
			var t = create_tween()
			t.set_ease(ea)
			t.set_trans(tr)
			t.tween_property(target, "self_modulate", color, dulation)

############### NOTES AND STRUMS ###############

func noteTween(dir = 0, property = "position:x", value = 0, dulation = 0, ea = Tween.EASE_IN, tr = Tween.TRANS_LINEAR):
	for i in notes.get_children():
		if i.dir == dir:
			var t = i.create_tween()
			t.set_ease(ea)
			t.set_trans(tr)
			t.tween_property(i, property, value, dulation)
	for i in strums.get_children():
		if i.dir == dir:
			var t = i.create_tween()
			t.set_ease(ea)
			t.set_trans(tr)
			t.tween_property(i, property, value, dulation)

func notePropertySet(dir = 0, property = "position:x", value = 0):
	for i in notes.get_children():
		if i.dir == dir:
			i[property] = value
	for i in strums.get_children():
		if i.dir == dir:
			i[property] = value

func notePropertySetAll(property = "position:x", value = 0):
	for i in notes.get_children():
		i[property] = value
	for i in strums.get_children():
		i[property] = value

func noteTweenDad(property = "position:x", value = 0, dulation = 0):
	for i in range(0, Game.key_count[Game.KC_DAD]):
		noteTween(i, property, value, dulation)

func noteTweenBF(property = "position:x", value = 0, dulation = 0):
	for i in range(Game.key_count[Game.KC_DAD], Game.key_count[Game.KC_DAD] + Game.key_count[Game.KC_BF]):
		noteTween(i, property, value, dulation)

func noteTweenBoth(property = "position:x", value = 0, dulation = 0):
	for i in range(0, Game.key_count[Game.KC_DAD] + Game.key_count[Game.KC_BF]):
		noteTween(i, property, value, dulation)

func hideStrum():
	strums.hide()

func showStrum():
	strums.show()

############### TEXT ###############

func stopUpdateText():
	info.stopUpdateText()
	ui.get_node("ColorRect/TimeBar").stopUpdateText()

func resumeUpdateText():
	info.resumeUpdateText()
	ui.get_node("ColorRect/TimeBar").resumeUpdateText()

func setTextString(tag, text):
	var target
	match tag:
		"scoreTxt":
			target = info.get_node("ScoreTxt/Label1")
		"timeTxt":
			target = ui.get_node("ColorRect/TimeBar/Label")
		"infoTxt":
			target = info.get_node("Label2")
		"engineTxt":
			target = info.get_node("Label3")
		"songTxt":
			target = info.get_node("Label4")
		"songDiffTxt":
			target = info.get_node("Label4/Difficulty")
		"kps":
			target = info.get_node("KPS")
		"kpsTxt":
			target = info.get_node("KPS/kps")
		"dadkps":
			target = info.get_node("DADKPS")
		"dadkpsTxt":
			target = info.get_node("DADKPS/kps")
		_:
			target = gameplay.get_node_or_null(tag)
	
	if target:
		target.text = text

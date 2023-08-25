extends CanvasLayer

@onready var bg = $BG
var spr: AnimatedSprite2D

enum {GAME, START, GAMEOVER, END}
var gameoverState := GAME

var last_beat := 0

var anim_offset: Dictionary
var anim_name: Dictionary

const DEFAULT_DEAD_XML = "BOYFRIEND_DEAD"
const DEFAULT_DEAD_JSON = "bf-dead"

const START_ANIM = "firstdeath"
const LOOP_ANIM = "deathloop"
const END_ANIM = "deathconfirm"

func _ready():
	# 曲の情報がロードされるまで待つ
	await Game.game_ready
	
	var dead_xml: String = Game.player1.to_upper() + "_DEAD"
	var json: Dictionary
	
	# スプライトのロード
	if Paths.p_chara_xml(dead_xml):
		spr = Game.load_XMLSprite(Paths.p_chara_xml(dead_xml), "bf dies", false, 24, 2)
		json = File.f_read(Paths.p_chara(Game.player1.to_lower() + "-dead"), ".json")
	else:
		spr = Game.load_XMLSprite(Paths.p_chara_xml(DEFAULT_DEAD_XML), "bf dies", false, 24, 2)
		json = File.f_read(Paths.p_chara(DEFAULT_DEAD_JSON), ".json")
	for i in json.animations:
		anim_offset[i.name.to_lower()] = Vector2(i.offsets[0] / -2.0, i.offsets[1] / -2.0)
		anim_name[i.anim.to_lower()] = i.name.to_lower()
	
	spr.name = "Sprite"
	spr.visible = false
	add_child(spr)


func _process(_delta):
	if gameoverState == START:
		spr.position = lerp(spr.position, Vector2(640, 400), 0.1)
	if gameoverState == GAMEOVER:
		spr.scale = lerp(spr.scale, Vector2(1.0, 1.0), 0.1)
		if last_beat != Audio.a_get_beat("Gameover"):
			spr.stop()
			spr.play(anim_name[LOOP_ANIM])
			spr.offset = anim_offset[anim_name[LOOP_ANIM]]
			
			last_beat = Audio.a_get_beat("Gameover")
			spr.scale = Vector2(1.05, 1.05)

func gameover(): #ゲームオーバー
	gameoverState = START
	Game.cur_state = Game.GAMEOVER
	
	Audio.a_stop("Inst")
	Audio.a_stop("Voices")
	Audio.a_play("GameoverStart")
	
	spr.stop()
	spr.play(anim_name[START_ANIM])
	spr.offset = anim_offset[anim_name[START_ANIM]]
	if Game.is3D:
		spr.position = $/root/Gameplay3D/Characters/bfpos.getPosOffset()
	else:
		spr.position = $/root/Gameplay/Characters/bfpos.getPosOffset()
	spr.visible = true
	bg.visible = true
	
	await get_tree().create_timer(2.5).timeout
	
	if gameoverState == START and Game.cur_state == Game.GAMEOVER:
		Audio.a_play("Gameover")
		gameoverState = GAMEOVER


func accepted(): #リトライ決定
	if Game.cur_state == Game.GAMEOVER and gameoverState != END:
		gameoverState = END
		if Audio.a_check("Gameover"):
			Audio.a_stop("Gameover")
		Audio.a_play("GameoverEnd")
		spr.play(anim_name[END_ANIM])
		spr.offset = anim_offset[anim_name[END_ANIM]]
		
		spr.scale = Vector2(1.05, 1.05)
		
		
		await get_tree().create_timer(2).timeout
		
		if Game.cur_state == Game.GAMEOVER: #リトライ決定してからドタキャンした場合の条件分岐
			get_parent().moveSong(Game.cur_song)

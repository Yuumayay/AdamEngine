extends CanvasLayer

@onready var bg = $BG
var spr: AnimatedSprite2D

enum {GAME, START, GAMEOVER, END}
var gameoverState := 0

var last_beat := 0


func _ready():
	# 曲の情報がロードされるまで待つ
	await Game.game_ready
	
	# スプライトのロード
	spr = Game.load_XMLSprite("res://Assets/Images/characters/BOYFRIEND_DEAD.xml", "bf dies", false, 24, 2)
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
			spr.play("bf dead loop")
			
			last_beat = Audio.a_get_beat("Gameover")
			spr.scale = Vector2(1.05, 1.05)

func gameover(): #ゲームオーバー
	gameoverState = START
	Game.cur_state = Game.GAMEOVER
	
	Audio.a_stop("Inst")
	Audio.a_stop("Voices")
	Audio.a_play("GameoverStart")
	
	spr.stop()
	spr.play("bf dies")
	spr.position = Game.bfPos
	spr.visible = true
	bg.visible = true
	
	await get_tree().create_timer(2.5).timeout
	
	Audio.a_play("Gameover")
	gameoverState = GAMEOVER


func accepted(): #リトライ決定
	gameoverState = END
	if Audio.a_check("Gameover"):
		Audio.a_stop("Gameover")
	elif Audio.a_check("GameoverStart"):
		Audio.a_stop("GameoverStart")
	Audio.a_play("GameoverEnd")
	spr.play("bf dead confirm")
	
	await get_tree().create_timer(2.5).timeout
	
	if Game.can_input: #リトライ決定してからドタキャンした場合の条件分岐
		get_parent().moveSong(Game.cur_song)

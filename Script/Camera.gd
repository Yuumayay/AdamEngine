extends Camera2D

enum {NORMAL, MODCHART}
var state := 0

var beat := 0
var spr: AnimatedSprite2D
var camPos: Vector2
var camZoom: float
var camSpeed: float
var zoomSpeed: float

const baseSpeed := 0.05

func _process(_delta):
	if state == NORMAL:
		zoom = lerp(zoom, Vector2(Game.defaultZoom, Game.defaultZoom), baseSpeed * 2)
		if Game.mustHit:
			position = lerp(position, Game.bfPos + Vector2(-100, -100), baseSpeed)
		else:
			position = lerp(position, Game.dadPos + Vector2(100, -100), baseSpeed)
		if beat != Audio.cur_section:
			beat = Audio.cur_section
			zoom = Vector2(Game.defaultZoom + 0.025, Game.defaultZoom + 0.025)
	elif state == MODCHART:
		position = lerp(position, camPos, camSpeed)
		zoom = lerp(zoom, Vector2(camZoom, camZoom), zoomSpeed)

func camMove(pos: Vector2, value = Game.defaultZoom, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0):
	camPos = pos
	camZoom = value
	camSpeed = cspeed * baseSpeed
	zoomSpeed = zspeed * baseSpeed
	
	state = MODCHART
	
	if sec == -1:
		return
	else:
		await get_tree().create_timer(sec).timeout
	
	state = NORMAL

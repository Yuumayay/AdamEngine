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

var bf
var dad
var gf

const BF_CAMERA_OFFSET =  Vector2(-100, -100)
const DAD_CAMERA_OFFSET =  Vector2(100, -100)

func _process(_delta):
	if Game.cur_state == Game.NOT_PLAYING: return
	if state == NORMAL:
		zoom = lerp(zoom, Vector2(Game.defaultZoom, Game.defaultZoom), baseSpeed * 2)
		if Game.mustHit:
			#position = lerp(position, bf.getPosOffset() + bf.getCamOffset() * dad.getScale() + BF_CAMERA_OFFSET, baseSpeed)
			position = lerp(position, bf.getPosOffset(), baseSpeed)
		else:
			#position = lerp(position, dad.getPosOffset() + dad.getCamOffset() * dad.getScale() + DAD_CAMERA_OFFSET, baseSpeed)
			position = lerp(position, dad.getPosOffset(), baseSpeed)
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

func camShake(intensity, dulation):
	for i in range(floor(dulation * 1000.0)):
		var rand_x = randf_range(float(-intensity), float(intensity))
		var rand_y = randf_range(float(-intensity), float(intensity))
		offset = Vector2(rand_x, rand_y)
		await get_tree().create_timer(0).timeout
	offset = Vector2.ZERO
		

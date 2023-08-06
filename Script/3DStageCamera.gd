extends Camera3D

enum {NORMAL, MODCHART}
var state := 0

var beat := 0
var spr: AnimatedSprite2D
var camPos: Vector3
var camZoom: float
var camSpeed: float
var zoomSpeed: float

const baseSpeed := 0.05

var bf
var dad
var gf

var defaultPos = Vector3(0.0, 0.55, 8.353)
var offsetbf = Vector3(10, 0, 5)
var offsetdad = Vector3(0, 0, 5)

func _process(_delta):
	if Game.cur_state == Game.NOT_PLAYING: return
	if state == NORMAL:
		fov = lerp(fov, Game.defaultZoom * 75, baseSpeed * 2)
		if Game.mustHit:
			position = lerp(position, bf.getPosOffset3D() + defaultPos, baseSpeed)
			look_at(bf.getPosOffset3D() - position + offsetbf)
		else:
			position = lerp(position, dad.getPosOffset3D() + defaultPos, baseSpeed)
			look_at(dad.getPosOffset3D() - position + offsetdad)
		if beat != Audio.cur_section:
			beat = Audio.cur_section
			fov = (Game.defaultZoom + 0.025) * 75
	elif state == MODCHART:
		position = lerp(position, camPos, camSpeed)
		fov = lerp(fov, camZoom * 75, zoomSpeed)

func camMove(pos: Vector3, value = Game.defaultZoom, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0):
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

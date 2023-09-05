extends Camera2D

enum {NORMAL, MODCHART, LOCK}
var state := 0

var beat := 0
var spr: AnimatedSprite2D
var camPos: Vector2
var camZoom: float
var camSpeed: float
var zoomSpeed: float
var lock_move := Vector2.ZERO

const baseSpeed := 0.05

var bf
var dad
var gf

const BF_CAMERA_OFFSET =  Vector2(-100, -100)
const DAD_CAMERA_OFFSET =  Vector2(100, -100)
const CAM_LOCK_MOVE = 100

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
	elif state == LOCK:
		var input
		var kc
		if Game.mustHit:
			input = Game.cur_input
			kc = Game.KC_BF
		else:
			input = Game.dad_input
			kc = Game.KC_DAD
		var index := 0
		for i in input:
			if i == 2:
				var anim_name = View.keys[str(Game.key_count[kc]) + "k"][index]
				if anim_name.contains("left"):
					lock_move = Vector2(-CAM_LOCK_MOVE, 0)
				elif anim_name.contains("up"):
					lock_move = Vector2(0, -CAM_LOCK_MOVE)
				elif anim_name.contains("down"):
					lock_move = Vector2(0, CAM_LOCK_MOVE)
				elif anim_name.contains("right"):
					lock_move = Vector2(CAM_LOCK_MOVE, 0)
			index += 1
		position = lerp(position, gf.getPosOffset() + lock_move, baseSpeed)
		zoom = lerp(zoom, Vector2(camZoom, camZoom), zoomSpeed)
		lock_move = lerp(lock_move, Vector2.ZERO, baseSpeed)

func camMove(pos = Vector2.ZERO, value = Game.defaultZoom, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0):
	if pos is Vector2:
		camPos = pos
	camZoom = value
	camSpeed = cspeed * baseSpeed
	zoomSpeed = zspeed * baseSpeed
	
	if state != LOCK:
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
		

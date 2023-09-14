extends Camera3D

enum {NORMAL, MODCHART, LOCK, ZOOM}
var state := 0

var beat := 0
var spr: AnimatedSprite2D
var camPos: Vector3
var camZoom: float
var camSpeed: float
var zoomSpeed: float

var lock_move := Vector3.ZERO

const baseSpeed := 0.05

var bf
var dad
var gf

var defaultPos = Vector3(0.0, 0.55, 8.353)
var offsetbf = Vector3(10, 0, 5)
var offsetdad = Vector3(0, 0, 5)

const CAM_LOCK_MOVE = 2

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
					lock_move = Vector3(-CAM_LOCK_MOVE, 0, 0)
				elif anim_name.contains("up"):
					lock_move = Vector3(0, CAM_LOCK_MOVE, 0)
				elif anim_name.contains("down"):
					lock_move = Vector3(0, -CAM_LOCK_MOVE, 0)
				elif anim_name.contains("right"):
					lock_move = Vector3(CAM_LOCK_MOVE, 0, 0)
			index += 1
		position = lerp(position, gf.getPosOffset3D() + lock_move + defaultPos, baseSpeed)
		fov = lerp(fov, camZoom * 75, zoomSpeed)
		lock_move = lerp(lock_move, Vector3.ZERO, baseSpeed)
	elif state == ZOOM:
		fov = lerp(fov, camZoom * 75, zoomSpeed)
		if Game.mustHit:
			#position = lerp(position, bf.getPosOffset() + bf.getCamOffset() * dad.getScale() + BF_CAMERA_OFFSET, baseSpeed)
			position = lerp(position, bf.getPosOffset3D() + defaultPos, baseSpeed)
		else:
			#position = lerp(position, dad.getPosOffset() + dad.getCamOffset() * dad.getScale() + DAD_CAMERA_OFFSET, baseSpeed)
			position = lerp(position, dad.getPosOffset3D() + defaultPos, baseSpeed)

func camMove(pos = Vector3.ZERO, value = Game.defaultZoom, sec = 60.0 / Audio.bpm, cspeed = 1.0, zspeed = 1.0):
	if pos is Vector3:
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
		var rand_z = randf_range(float(-intensity), float(intensity))
		global_position = Vector3(rand_x, rand_y, rand_z)
		await get_tree().create_timer(0).timeout
	global_position = Vector3.ZERO

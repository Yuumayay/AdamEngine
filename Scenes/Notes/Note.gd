extends AnimatedSprite2D

@export var ind: int
@export var dir: int
@export var ms: float
@export var sus: int
@export var type: int
@export var player: int
@export var hit_ms: float
@export var free_f: bool = false
@export var dont_hit: bool = false
@export var do_hit: bool = false
@export var damage: float = 0.1
@export var hitsound: String = "hit2"
@export var misssound: String = "miss"
@export var up_or_down: int = 1
@onready var line: Line2D = $Line
var init_y: float = 0.
var elapsed_ms: float = 0.
var distance: float
var speed: float
var spawn_y: float

var held: Array = [preload("res://Assets/Images/Notes/Default/held/left hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/down hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/up hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/right hold0000.png")]

var remain_time := 0.1

var typename: Array = ["note", "hurt", "death", "caution", "shaggydeath", "bullet"]

func calc_distance():
	var note_distance = View.strum_pos[dir].y - spawn_y
	var p_ms = Game.get_preload_sec() * 1000
	var to_ms = ms - Audio.cur_ms # あと何msでhitする？
	var calc_distance2 = note_distance * (to_ms / p_ms) # あと何msでhit？と距離から、strumから遠ざける距離を決定
	return calc_distance2 * up_or_down

func calc_sus():
	# susのms から　Y距離を計算
	var distance_sus = (View.strum_pos[dir].y - spawn_y) * up_or_down
	var p_ms = Game.get_preload_sec() * 1000
	var distance_per_ms = distance_sus / p_ms # 1msにつき、移動すべきY距離　（速度
	var calc_distance_sus = distance_per_ms * sus # + Game.sus_tolerance # あと何msでhit？と距離から、strumから遠ざける距離を決定
	return calc_distance_sus

func _ready():
	if Setting.s_get("gameplay", "downscroll"):
		spawn_y = View.note_spawn_y[0]
	else:
		spawn_y = View.note_spawn_y[1]
	if dir >= Game.key_count * 2:
		var over = floor(float(dir) / float(Game.key_count))
		if Game.who_sing[ind]:
			dir = dir - (Game.key_count * over - Game.key_count)
		else:
			dir = dir - Game.key_count * over
		print(over, ", ", dir)
		if over == 2:
			type = 4
			dont_hit = true
		elif over == 3:
			type = 3
			do_hit = true
		elif over == 4:
			type = 3
			do_hit = true
	elif dir < 0:
		dir = abs(dir)
	#preload_sec = Game.get_preload_sec() # ノーツのスピードを決定する先読み時間を生成時にノーツに設定
			
	scale = Vector2(0.75 * (4.0 / Game.key_count), 0.75 * (4.0 / Game.key_count))
			
	# X座標をストラムにあわせる
	position = View.strum_pos[dir]
	
	# 読み出した時間を考慮してY位置を計算
	position.y = View.strum_pos[dir].y + calc_distance()
	
	
	if type == 0:
		animation = Game.note_anim[dir - player * Game.key_count]
	else:
		animation = typename[type]
	
	var linelen = calc_sus() * up_or_down * -1
	
	if linelen == 0:
		line.hide()
	else:
		line.set_point_position(1, Vector2(0, linelen / scale.y)) #親のスケールに依存しないのでスケールでわる
		line.texture = held[dir % 4]
		line.modulate.a = 0.5
	if dir == 0:
		pass
	
	speed = (View.strum_pos[dir].y - spawn_y) / (Game.get_preload_sec())
	
	#print("note check:", Audio.cur_ms, "@ ", to_ms, " ", calc_distance, " / ", speed*(to_ms/1000), " diff: ", calc_distance - speed*(to_ms/1000) )

	Game.notes_data.notes.append(self)

func update_linelen():
	#長押しラインの長さをアップデート
	line.set_point_position(0, Vector2(0, (View.strum_pos[dir].y - position.y) / scale.y)) #親のスケールに依存しないのでスケールでわる

func posUpdate():
	if Setting.s_get("gameplay", "downscroll"):
		spawn_y = View.note_spawn_y[0]
	else:
		spawn_y = View.note_spawn_y[1]
	
	# X座標をストラムにあわせる
	position = View.strum_pos[dir]
	
	# 読み出した時間を考慮してY位置を計算
	position.y = View.strum_pos[dir].y + calc_distance() * up_or_down *-1
	
	var linelen = calc_sus() * up_or_down * -1
	line.set_point_position(1, Vector2(0, linelen / scale.y)) #親のスケールに依存しないのでスケールでわる
	line.texture = held[dir % 4]
	line.modulate.a = 0.5
	
	speed = (View.strum_pos[dir].y - spawn_y) / (Game.get_preload_sec())

var last_audio_ms = 0.0
func _process(delta):
	if Game.cur_state == Game.NOT_PLAYING or Game.cur_state == Game.PAUSE or Game.cur_state == Game.GAMEOVER: return
	
	#print(delta, " ", (Audio.cur_ms - last_audio_ms)/1000.0 )
	if absf(delta - (Audio.cur_ms - last_audio_ms)/1000.0) > 0.002:
		position.y = View.strum_pos[dir].y + calc_distance() * up_or_down *-1
	else:
		position.y += speed * delta
	
	if sus != 0 and !line.visible:
		line.show()
	
	last_audio_ms = Audio.cur_ms
	
	# queue_free
	if free_f:
		remain_time -= delta
		if remain_time <= 0:
			if modulate.a == 0.5:
				Audio.a_play("Miss" + str(randi_range(1, 3)), 1.0, -5.0)
				Game.add_rating(Game.MISS)
				Game.bf_miss[dir - Game.key_count] = 1
				Audio.a_volume_set("Voices", -80)
				if do_hit:
					Game.add_health(-999)
					Audio.a_play("Loss Matt")
				else:
					Game.add_health(-damage)
			#print("freed")
			queue_free()

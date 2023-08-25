extends AnimatedSprite2D

@export var ind: int
@export var dir: int # fnfdir
@export var ms: float
@export var sus: int
@export var type: int # note type 特殊ノーツのタイプ！
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

var kc := 1

@onready var held: Array = View.held
@onready var arrowSpriteFrames: SpriteFrames = View.arrowSpriteFrames

var remain_time := 0.1

var typename: Array = ["note", "hurt", "death", "caution", "shaggydeath", "bullet"]

func calc_distance():
	var note_distance = strumPos.y - spawn_y
	var p_ms = Game.get_preload_sec() * 1000
	var to_ms = ms - Audio.cur_ms # あと何msでhitする？
	var calc_distance2 = note_distance * (to_ms / p_ms) # あと何msでhit？と距離から、strumから遠ざける距離を決定
	return calc_distance2 * up_or_down

func calc_sus():
	if sus <= 0.0:
		sus = 0
	
	# susのms から　Y距離を計算
	var distance_sus = (strumPos.y - spawn_y) * up_or_down
	var p_ms = Game.get_preload_sec() * 1000
	var distance_per_ms = distance_sus / p_ms # 1msにつき、移動すべきY距離　（速度
	var calc_distance_sus = distance_per_ms * sus # + Game.sus_tolerance # あと何msでhit？と距離から、strumから遠ざける距離を決定
	return calc_distance_sus

var strumPos: Vector2

func _ready():
	dir = clamp(dir, 0, Game.key_count[Game.KC_BF] + Game.key_count[Game.KC_DAD] + Game.key_count[Game.KC_GF] - 1)
	if player == 1:
		kc = 0
	sprite_frames = arrowSpriteFrames
	if Setting.s_get("gameplay", "downscroll"):
		spawn_y = View.note_spawn_y[0]
	else:
		spawn_y = View.note_spawn_y[1]
	
	scale = Vector2(0.75 * (4.0 / Game.key_count[kc]), 0.75 * (4.0 / Game.key_count[kc]))
	
	if player == 2: # GFかどうか
		print(dir)
		dir -= Game.key_count[Game.KC_BF] + Game.key_count[Game.KC_DAD]
		strumPos = View.gf_strum_pos[dir]
		scale = Vector2(0.5 * (4.0 / Game.key_count[kc]), 0.5 * (4.0 / Game.key_count[kc]))
	else:
		strumPos = View.strum_pos[dir]
	if dir < 0:
		dir = abs(dir)
	#preload_sec = Game.get_preload_sec() # ノーツのスピードを決定する先読み時間を生成時にノーツに設定
	
	
	# X座標をストラムにあわせる
	position = strumPos
	
	# 読み出した時間を考慮してY位置を計算
	position.y = strumPos.y + calc_distance()
	
	if type == 0:
		animation = Game.note_anim[dir]
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
	
	speed = (strumPos.y - spawn_y) / (Game.get_preload_sec())
	
	#print("note check:", Audio.cur_ms, "@ ", to_ms, " ", calc_distance, " / ", speed*(to_ms/1000), " diff: ", calc_distance - speed*(to_ms/1000) )

	Game.notes_data.notes.append(self)

func update_linelen():
	#長押しラインの長さをアップデート
	line.set_point_position(0, Vector2(0, (strumPos.y - position.y) / scale.y)) #親のスケールに依存しないのでスケールでわる

func posUpdate():
	if Setting.s_get("gameplay", "downscroll"):
		spawn_y = View.note_spawn_y[0]
	else:
		spawn_y = View.note_spawn_y[1]
	
	# X座標をストラムにあわせる
	position = strumPos
	
	# 読み出した時間を考慮してY位置を計算
	position.y = strumPos.y + calc_distance() * up_or_down *-1
	
	var linelen = calc_sus() * up_or_down * -1
	line.set_point_position(1, Vector2(0, linelen / scale.y)) #親のスケールに依存しないのでスケールでわる
	line.texture = held[dir % 4]
	line.modulate.a = 0.5
	
	speed = (strumPos.y - spawn_y) / (Game.get_preload_sec())

var last_audio_ms = 0.0
func _process(delta):
	if Game.cur_state == Game.NOT_PLAYING or Game.cur_state == Game.PAUSE or Game.cur_state == Game.GAMEOVER: return
	
	#print(delta, " ", (Audio.cur_ms - last_audio_ms)/1000.0 )
	if absf(delta - (Audio.cur_ms - last_audio_ms)/1000.0) > 0.002:
		position.y = strumPos.y + calc_distance() * up_or_down *-1
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
				Audio.a_play("Miss" + str(randi_range(1, 3)), 1.0, -10.0)
				Game.add_rating(Game.MISS)
				Game.bf_miss[dir - Game.key_count[Game.KC_DAD]] = 1
				Audio.a_volume_set("Voices", -80)
				if do_hit:
					Game.add_health(-999)
					Audio.a_play("Loss Matt")
				else:
					Game.add_health(-damage)
			#print("freed")
			queue_free()

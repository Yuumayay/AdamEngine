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

var held: Array = [preload("res://Assets/Images/Notes/Default/held/left hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/down hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/up hold0000.png"),
preload("res://Assets/Images/Notes/Default/held/right hold0000.png")]

var remain_time := 0.1

var typename: Array = ["note", "hurt", "death", "caution", "shaggydeath", "bullet"]

func _ready():
	if dir >= Game.key_count * 2:
		var over = floor(dir / Game.key_count)
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
	position = View.strum_pos[dir]
	position.y = View.note_spawn_y[0]
	scale = Vector2(0.7 * (4.0 / Game.key_count), 0.7 * (4.0 / Game.key_count))
	if type == 0:
		animation = Game.note_anim[dir - player * Game.key_count]
	else:
		animation = typename[type]
	line.set_point_position(1, Vector2(0, sus * up_or_down * -1))
	line.texture = held[dir % 4]
	line.modulate.a = 0.5
	if dir == 0:
		pass
	
	var psec = Game.get_preload_sec()
	#speed = (View.strum_pos[dir].y - View.note_spawn_y[0]) / (Game.PRELOAD_SEC / Game.cur_speed) * Game.cur_multi * up_or_down
	speed = (View.strum_pos[dir].y - View.note_spawn_y[0]) / (psec)
	#position.y = View.strum_pos[dir].y + View.note_spawn_y[0] * ((ms - Audio.cur_ms) / (psec / Game.cur_speed * 1000))
	
	Game.notes_data.notes.append(self)
	
func _process(delta):
	if Game.cur_state == Game.NOT_PLAYING or Game.cur_state == Game.PAUSE: return
	if visible:
		#position.y = View.strum_pos[dir].y + (Audio.cur_ms - ms) 
		position.y += speed * delta
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

extends ColorRect

@export var dir: int
@export var ms: float
@export var sus: float
@export var note_type: int

# n番目のplayer_type
@export var player_ind: int

# どの種類か
enum {EVENT, BF, DAD, GF}
@export var player_type: int

@onready var note = get_node("Note")
@onready var line = get_node("Line")

var hit: bool = false

func _ready():
	if Chart.placed_notes.notes.has([dir, ms, player_type, player_ind]):
		var sustain = Chart.placed_notes.notes.find([dir, ms, player_type, player_ind])
		print("find")
		if Chart.notes_property.notes[sustain][1] != 0:
			line.set_point_position(1, Vector2(0, Chart.notes_property.notes[sustain][1] + 25))
			sus = Chart.notes_property.notes[sustain][1]
			note_type = Chart.notes_property.notes[sustain][2]
		if player_type == EVENT:
			note.animation = "event"
		else:
			anim_set()
		note.visible = true
		line.visible = true

func anim_set():
	if player_type == BF:
		note.animation = View.keys[str(Chart.bf_data["key_count"][player_ind]) + "k"][dir]
	elif player_type == DAD:
		note.animation = View.keys[str(Chart.dad_data["key_count"][player_ind]) + "k"][dir]
	elif player_type == GF:
		note.animation = View.keys[str(Chart.gf_data["key_count"][player_ind]) + "k"][dir]

func _process(_delta):
	place()
	scroll()
	
func place():
	if abs(global_position.x + 24 - get_global_mouse_position().x) <= 24 and abs(global_position.y + 24 - get_global_mouse_position().y) <= 24:
		if Input.is_action_just_pressed("game_click") and Chart.can_input:
			if note.visible:
				print("removed")
				note.visible = false
				line.visible = false
				Audio.a_play("Erase")
				Chart.placed_notes.notes.erase([dir, ms, player_type, player_ind])
				Chart.notes_property.notes.erase([player_ind, sus, note_type])
			else:
				var distance
				
				print("added")
				if player_type == EVENT:
					note.animation = "event"
				else:
					anim_set()
				note.visible = true
				line.visible = true
				
				Audio.a_play("Place")
				while Input.is_action_pressed("game_click"):
					distance = floor(floor(global_position.y - get_global_mouse_position().y) / 50) * -50 - 50
					print(distance)
					if distance <= 0:
						sus = 0
						line.set_point_position(1, Vector2(0, 0))
					else:
						sus = distance
						line.set_point_position(1, Vector2(0, distance + 25))
					await get_tree().create_timer(0).timeout
				Chart.placed_notes.notes.append([dir, ms, player_type, player_ind])
				Chart.notes_property.notes.append([player_ind, sus, note_type])
			print(Chart.placed_notes.notes)
			print(Chart.notes_property.notes)
	
func scroll():
	position.y = ms * 50 + Chart.cur_y + 300
	if Chart.playing:
		if global_position.y <= 301 and note.visible and not hit:
			hit = true
			Audio.a_play("Hit")
			note.modulate.a = 0.5
	else:
		if global_position.y <= 301 and note.visible:
			note.modulate.a = 0.5
			hit = true
		else:
			note.modulate.a = 1
			hit = false

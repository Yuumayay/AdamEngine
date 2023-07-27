extends ColorRect

@export var dir: int
@export var ms: float
@export var sus: float
@export var type: int

enum {EVENT, P1, P2}
@export var player: int

@onready var note = get_node("Note")
@onready var line = get_node("Line")

var hit: bool = false

func _ready():
	if Chart.placed_notes.notes.has([dir, ms, player, sus, type]):
		var sustain = Chart.placed_notes.notes.find([dir, ms, player, sus, type])
		print("find")
		if sustain != -1:
			line.set_point_position(1, Vector2(0, Chart.placed_notes.notes[sustain][3] + 25))
		if player == EVENT:
			note.animation = "event"
		else:
			note.animation = Game.note_anim[dir]
		note.visible = true
		line.visible = true

func _process(delta):
	place()
	scroll()
	
func place():
	if abs(global_position.x + 24 - get_global_mouse_position().x) <= 24 and abs(global_position.y + 24 - get_global_mouse_position().y) <= 24:
		if Input.is_action_just_pressed("game_click"):
			if note.visible:
				print("removed")
				note.visible = false
				line.visible = false
				Audio.a_play("Erase")
				Chart.placed_notes.notes.erase([dir, ms, player, sus, type])
			else:
				var distance
				
				print("added")
				if player == EVENT:
					note.animation = "event"
				else:
					note.animation = Game.note_anim[dir]
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
					await get_tree().create_timer(0.05).timeout
				Chart.placed_notes.notes.append([dir, ms, player, sus, type])
			print(Chart.placed_notes.notes)
	
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

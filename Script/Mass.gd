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

var note #= get_node("Note")
var line #= get_node("Line")

var hit: bool = false
var og_color : Color

@onready var Chart = get_parent()

func _ready():
	og_color = color
	for i in Chart.chartData.notes[Chart.cur_section]["sectionNotes"]:
		if i.ms == 60.0 / Chart.bpm * ms * 250 and i.dir == dir and i.player_type == player_type and i.player_ind == player_ind:
			var sustain = i.sus
			var note_type = i.note_type
			print("find")
			set_note_and_line()
			if sustain != 0:
				line.set_point_position(1, Vector2(0, sustain + 25))
				sus = sustain
				note_type = i.note_type
			if player_type == EVENT:
				note.animation = "square"
			else:
				anim_set()
			return

func set_note_and_line():
	note = Game.load_XMLSprite("Assets/Images/Notes/Default/default.xml")
	note.position = Vector2(25, 25)
	note.scale = Vector2(0.3, 0.3)
	line = Line2D.new()
	line.position = Vector2(25, 25)
	line.add_point(Vector2.ZERO, 0)
	line.add_point(Vector2.ZERO, 1)
	line.width = 10
	line.default_color = Color(1, 1, 1)
	add_child(note)
	add_child(line)

func erase_note_and_line():
	remove_child(note)
	remove_child(line)
	note = null
	line = null

func anim_set():
	if player_type == BF:
		note.animation = View.keys[str(Chart.bf_data["key_count"][player_ind]) + "k"][dir]
	elif player_type == DAD:
		note.animation = View.keys[str(Chart.dad_data["key_count"][player_ind]) + "k"][dir]
	elif player_type == GF:
		note.animation = View.keys[str(Chart.gf_data["key_count"][player_ind]) + "k"][dir]
	
func place():
			if note:
				print("removed")
				erase_note_and_line()
				Audio.a_play("Erase")
				Chart.chartData.notes[Chart.cur_section]["sectionNotes"].erase({"ms" = 60.0 / Chart.bpm * ms * 250, "dir" = dir, "sus" = sus, "note_type" = note_type, "player_type" = player_type, "player_ind" = player_ind})
			else:
				var distance
				set_note_and_line()
				print("added")
				if player_type == EVENT:
					note.animation = "square"
				else:
					anim_set()
				
				Audio.a_play("Place")
				while Input.is_action_pressed("game_click"):
					distance = floor(floor(global_position.y - get_global_mouse_position().y) / 50) * -50 - 50
					print(distance)
					if not note:
						break
					if distance <= 0:
						sus = 0
						line.set_point_position(1, Vector2(0, 0))
					else:
						sus = distance
						line.set_point_position(1, Vector2(0, distance + 25))
					await get_tree().create_timer(0).timeout
				Chart.chartData.notes[Chart.cur_section]["sectionNotes"].append({"ms" = 60.0 / Chart.bpm * ms * 250, "dir" = dir, "sus" = sus, "note_type" = note_type, "player_type" = player_type, "player_ind" = player_ind})
			print(Chart.chartData.notes)

func _on_button_button_down():
	pass
	#place()


func _on_button_mouse_entered():
	color = Color(1, 1, 1)


func _on_button_mouse_exited():
	color = og_color

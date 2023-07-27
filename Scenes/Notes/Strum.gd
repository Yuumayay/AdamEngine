extends AnimatedSprite2D

signal bf_hit

@export var dir: int

enum {AUTO_DAD, PLAYER, AUTO_PLAYER}
@export var type: int

var rating = preload("res://Scenes/Rating.tscn")

func _ready():
	if Game.note_anim[dir - type * Game.key_count].contains("2"):
		animation = Game.note_anim[dir - type * Game.key_count].replace("2", "") + " static"
	else:
		animation = Game.note_anim[dir - type * Game.key_count] + " static"

func _process(_delta):
	if Game.cur_state == Game.NOT_PLAYING: return
	if Game.cur_input[dir - type * Game.key_count] == 0:
		if Game.note_anim[dir - type * Game.key_count].contains("2"):
			animation = Game.note_anim[dir - type * Game.key_count].replace("2", "") + " static"
		else:
			animation = Game.note_anim[dir - type * Game.key_count] + " static"
	else:
		if animation.contains("confirm"):
			frame += 1
		else:
			if type == PLAYER:
				animation = Game.note_anim[dir - type * Game.key_count] + " press"
		
	if type == AUTO_DAD:
		bot_strum()
	elif type == PLAYER:
		player_strum()
	elif type == AUTO_PLAYER:
		playerbot_strum()


func bot_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		if Audio.cur_ms >= i.ms:
			if i.sus == 0:
				Game.dad_input[dir] = 2
				Audio.a_play("Hit")
				i.free_f = true
				i.visible = false
			else:
				if i.self_modulate.a != 0:
					Game.dad_input[dir] = 2
					Audio.a_play("Hit")
					i.self_modulate.a = 0
					break
				Game.dad_input[dir] = 1
				var line: Line2D = i.get_node("Line")
				line.set_point_position(0, Vector2(0, (View.strum_pos[dir].y - i.position.y) / i.scale.y))
				if absf(line.get_point_position(0).y - line.get_point_position(1).y) <= 50 * Game.cur_multi:
					Game.dad_input[dir] = 0
					i.free_f = true
					i.visible = false

func playerbot_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		if Audio.cur_ms >= i.ms:
			if i.sus == 0:
				Game.cur_input[dir - type * Game.key_count] = 2
				Audio.a_play("Hit")
				i.free_f = true
				i.visible = false
				i.hit_ms = 0.0
				judge(i.hit_ms, i.type)
			else:
				if i.self_modulate.a != 0:
					Game.cur_input[dir - type * Game.key_count] = 2
					Audio.a_play("Hit")
					i.self_modulate.a = 0
					i.hit_ms = 0.0
					judge(i.hit_ms, i.type)
					break
				Game.cur_input[dir - type * Game.key_count] = 1
				var line: Line2D = i.get_node("Line")
				line.set_point_position(0, Vector2(0, (View.strum_pos[dir].y - i.position.y) / i.scale.y))
				if absf(line.get_point_position(0).y - line.get_point_position(1).y) <= 50 * Game.cur_multi:
					Game.cur_input[dir - type * Game.key_count] = 0
					i.free_f = true
					i.visible = false

func player_strum():
	for i in Game.notes_data.notes:
		if !i or i.free_f or dir != i.dir:
			continue
		var msdiff = Audio.cur_ms - i.ms
		if Audio.cur_ms >= i.ms - Game.rating_offset[Game.MISS]:
			if i.sus == 0:
				if Game.cur_input[dir - type * Game.key_count] == 2:
					animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
					Audio.a_play("Hit")
					i.free_f = true
					i.visible = false
					i.hit_ms = msdiff
					judge(i.hit_ms, i.type)
					break
				if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS]:
					i.free_f = true
					i.modulate.a = 0.5
			else:
				if i.self_modulate.a == 0:
					if Game.cur_input[dir - type * Game.key_count] == 1:
						i.self_modulate.a = 0
						var line: Line2D = i.get_node("Line")
						if msdiff >= 0:
							line.set_point_position(0, Vector2(0, (View.strum_pos[dir].y - i.position.y) / i.scale.y))
						if line.get_point_position(0).y + 50 * i.up_or_down <= line.get_point_position(1).y:
							i.free_f = true
							i.visible = false
					else:
						i.free_f = true
						i.modulate.a = 0.5
				else:
					if Game.cur_input[dir - type * Game.key_count] == 2:
						animation = Game.note_anim[dir - type * Game.key_count] + " confirm"
						Audio.a_play("Hit")
						i.self_modulate.a = 0
						i.hit_ms = msdiff
						judge(i.hit_ms, i.type)
						break
					if Audio.cur_ms - i.ms >= Game.rating_offset[Game.MISS]:
						i.free_f = true
						i.modulate.a = 0.5

func judge(hit_ms, type):
	emit_signal("bf_hit")
	
	var ms = abs(hit_ms)
	var layer = rating.instantiate()
	var new_rating = layer.get_node("Rating")
	
	if type == 4:
		Audio.a_play("Loss Shaggy")
		Game.add_rating(Game.MISS)
		Game.add_health(-999)
		Game.add_score(Game.score_gain[Game.MISS])
	elif ms <= Game.rating_offset[Game.PERF + 1]:
		new_rating.frame = Game.PERF
		Game.add_rating(Game.PERF)
		Game.add_health(Game.health_gain[Game.PERF])
		Game.add_score(Game.score_gain[Game.PERF])
	elif ms <= Game.rating_offset[Game.SICK + 1]:
		new_rating.frame = Game.SICK
		Game.add_rating(Game.SICK)
		Game.add_health(Game.health_gain[Game.SICK])
		Game.add_score(Game.score_gain[Game.SICK])
	elif ms <= Game.rating_offset[Game.GOOD + 1]:
		new_rating.frame = Game.GOOD
		Game.add_rating(Game.GOOD)
		Game.add_health(Game.health_gain[Game.GOOD])
		Game.add_score(Game.score_gain[Game.GOOD])
	elif ms <= Game.rating_offset[Game.BAD + 1]:
		new_rating.frame = Game.BAD
		Game.add_rating(Game.BAD)
		Game.add_health(Game.health_gain[Game.BAD])
		Game.add_score(Game.score_gain[Game.BAD])
	elif ms <= Game.rating_offset[Game.SHIT + 1]:
		new_rating.frame = Game.SHIT
		Game.add_rating(Game.SHIT)
		Game.add_health(Game.health_gain[Game.SHIT])
		Game.add_score(Game.score_gain[Game.SHIT])
	else:
		return
	
	var mstext = layer.get_node("Label")
	mstext.ms = hit_ms
	
	$/root.add_child(layer)

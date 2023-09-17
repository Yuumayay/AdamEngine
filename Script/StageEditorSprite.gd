extends TextureRect

@onready var position_label: Label = $PosLabel

var icons := [["visible_icon", [0, 1]], ["flip_h_icon", [2]], ["flip_v_icon", [3]], ["modulate_icon", [4]],
["delete_icon", [8]], ["duplicate_icon", [9]]]

var image_path: String = Paths.missing
var xml_path: String
var mouse_enter := false

var animated := false
var anim_size: Vector2
var anim_spr: AnimatedSprite2D
var loop_type := 6
enum {LOOP = 5, BEAT = 6, STOP = 7}
var has_idle := false

var duplicated := false
var can_delete := true
var can_duplicate := true

func _ready():
	if $icons.get_child_count() != 0: duplicated = true
	if not duplicated:
		if xml_path:
			animated = true
			anim_spr = Game.load_XMLSprite(xml_path)
			if anim_spr.sprite_frames.has_animation("idle"):
				has_idle = true
				anim_spr.play("idle")
				anim_size = anim_spr.sprite_frames.get_frame_texture("idle", 0).get_size()
			else:
				anim_size = anim_spr.sprite_frames.get_frame_texture(anim_spr.animation, 0).get_size()
			anim_spr.name = "AnimSpr"
			anim_spr.z_index += 1
			var drag = Control.new()
			drag.size = anim_size
			drag.position = anim_size / -2.0
			drag.mouse_entered.connect(_on_mouse_entered)
			drag.mouse_exited.connect(_on_mouse_exited)
			anim_spr.add_child(drag)
			add_child(anim_spr)
			icons.append(["loop_type_icon", [5, 6, 7]])
		else:
			texture = Game.load_image(image_path)
		var editorIcon = Game.load_image("Assets/Images/Editor/editorIcons.png")
		var total_x := 0
		var total_y := 0
		for i in icons:
			if i[0] == "delete_icon" and not can_delete:
				return
			if i[0] == "duplicate_icon" and not can_duplicate:
				return
			var spr = Sprite2D.new()
			spr.set_script(load("Script/EditorIcon.gd"))
			spr.texture = editorIcon
			spr.name = i[0]
			spr.hframes = 8
			spr.vframes = 2
			if spr.name == "loop_type_icon":
				spr.frame = BEAT
				spr.frame_ind = 1
			else:
				spr.frame = i[1][0]
			spr.frame_array = i[1]
			spr.position.x = total_x
			if animated:
				spr.position.y = anim_size.y + 10 + total_y
				spr.position -= anim_size / 2.0
			else:
				spr.position.y = texture.get_size().y + 10 + total_y
			spr.scale = Vector2(0.55, 0.55)
			spr.centered = false
			spr.z_index = 2
			total_x += 40
			if total_x >= 160:
				total_x = 0
				total_y += 40
			var button = Button.new()
			button.set_anchors_preset(Control.PRESET_FULL_RECT)
			button.name = "Button"
			button.modulate.a = 0
			spr.add_child(button)
			$icons.add_child(spr)
	else:
		if xml_path:
			animated = true
			anim_spr = $AnimSpr
			if anim_spr.sprite_frames.has_animation("idle"):
				has_idle = true
				anim_spr.play("idle")
				anim_size = anim_spr.sprite_frames.get_frame_texture("idle", 0).get_size()
			else:
				anim_size = anim_spr.sprite_frames.get_frame_texture(anim_spr.animation, 0).get_size()
			anim_spr.name = "AnimSpr"
			anim_spr.z_index += 1
			var drag = Control.new()
			drag.size = anim_size
			drag.position = anim_size / -2.0
			drag.mouse_entered.connect(_on_mouse_entered)
			drag.mouse_exited.connect(_on_mouse_exited)
			anim_spr.add_child(drag)
			icons.append(["loop_type_icon", [5, 6, 7]])
		var index := 0
		for i in $icons.get_children():
			if i.name == "loop_type_icon":
				i.frame = BEAT
				i.frame_ind = 1
			else:
				i.frame = icons[index][1][0]
			i.frame_array = icons[index][1]
			index += 1

var is_drag := false
var drag_offset := Vector2.ZERO

var beat := 0
var beat_hit = false

func _process(_delta):
	var get_beat = Audio.a_get_beat("Option Menu", 2)
	position_label.text = "Pos: " + str(position) + "\nScale: " + str(scale)
	beat_hit = false
	if beat != get_beat:
		beat = get_beat
		beat_hit = true
	if animated:
		if has_idle:
			if loop_type == BEAT:
				if anim_spr.frame >= anim_spr.sprite_frames.get_frame_count(anim_spr.animation):
					anim_spr.pause()
				if beat_hit:
					anim_spr.play(anim_spr.animation)
			elif loop_type == LOOP:
				if !anim_spr.is_playing():
					anim_spr.play(anim_spr.animation)
			elif loop_type == STOP:
				if anim_spr.is_playing():
					anim_spr.pause()
	if Input.is_action_just_pressed("game_click") and mouse_enter:
		drag_offset = position - get_global_mouse_position()
		is_drag = true
	if Input.is_action_just_released("game_click") and is_drag:
		is_drag = false
	if is_drag:
		position = get_global_mouse_position() + drag_offset

func visible_icon_pressed():
	var target = self
	if animated:
		target = anim_spr
	if target.self_modulate.a == 1:
		target.self_modulate.a = 0.5
	else:
		target.self_modulate.a = 1

func flip_h_icon_pressed():
	var target = self
	if animated:
		target = anim_spr
	target.flip_h = !target.flip_h

func flip_v_icon_pressed():
	var target = self
	if animated:
		target = anim_spr
	target.flip_v = !target.flip_v

func delete_icon_pressed():
	queue_free()

func duplicate_icon_pressed():
	var self_duplicate = duplicate()
	if animated:
		self_duplicate.xml_path = xml_path
	else:
		self_duplicate.image_path = image_path
	self_duplicate.position += Vector2(50, -50)
	get_parent().add_child(self_duplicate)

func loop_type_icon_pressed():
	if $icons/loop_type_icon.frame == LOOP: # LOOP
		loop_type = LOOP
	elif $icons/loop_type_icon.frame == BEAT: # BEAT
		loop_type = BEAT
	elif $icons/loop_type_icon.frame == STOP: # STOP
		loop_type = STOP
	anim_spr.stop()
	anim_spr.play(anim_spr.animation)

func modulate_icon_pressed():
	$ColorPicker.show()

func _on_mouse_entered():
	print("enter")
	mouse_enter = true


func _on_mouse_exited():
	print("exit")
	$ColorPicker.hide()
	mouse_enter = false


func _on_color_picker_color_changed(color):
	self_modulate = color

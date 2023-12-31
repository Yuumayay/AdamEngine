extends CanvasLayer

@onready var sprite: Sprite2D = $Sprite
@onready var root = $/root

var cur_scene = "Title Menu"
var last_scene = "Title Menu"

func _ready():
	cur_scene = get_tree().current_scene.name

func t_trans(change_to) -> void:
	Game.trans = true
	Game.can_input = false
	sprite.position.y = -2160
	
	var next_scene = load("res://Scenes/" + change_to + ".tscn").instantiate()
	
	visible = true
	
	var t = create_tween()
	t.tween_property(sprite, "position", Vector2(sprite.position.x, -500), 0.25)
	t.play()
	
	await get_tree().create_timer(0.25).timeout
	
	var removenode = root.get_node(NodePath(cur_scene))
	if removenode:
		root.remove_child(removenode)
		
	last_scene = cur_scene
	cur_scene = change_to
	
	root.add_child(next_scene)
	
	var t2 = create_tween()
	t2.tween_property(sprite, "position", Vector2(sprite.position.x, 1440), 0.25)
	t2.play()
	
	await get_tree().create_timer(0.25).timeout
	
	Game.can_input = true
	
	visible = false
	
	Game.trans = false
	
	sprite.position.y = -1080
	
	return

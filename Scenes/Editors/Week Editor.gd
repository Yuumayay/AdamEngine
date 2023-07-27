extends Node2D

@onready var iconlist: ItemList = $UI/IconList

func _ready():
	for i in DirAccess.get_files_at("res://Assets/Images/Icons"):
		if i.contains(".import"): continue
		var icon: CompressedTexture2D = load("res://Assets/Images/Icons/" + i)
		iconlist.add_item(i.replace(".png", ""), icon)

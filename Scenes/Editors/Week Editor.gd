extends Node2D

@onready var iconlist: ItemList = $UI/IconList

func _ready():
	for i in DirAccess.get_files_at("Assets/Images/Icons"):
		if i.contains(".import"): continue
		var icon: CompressedTexture2D = Game.load_image("Assets/Images/Icons/" + i)
		iconlist.add_item(i.replace(".png", ""), icon)

extends HBoxContainer

@export var IconScene : PackedScene

func SetMaxIcons(Amnt : int):
	for i in range(Amnt):
		var newIcon = IconScene.instantiate()
		add_child(newIcon)

func UpdateIcons(CurrentAmnt : int):
	var icons = get_children()
	
	for i in range(CurrentAmnt):
		icons[i].UpdateFill(true)
		
	for i in range(CurrentAmnt, icons.size()):
		icons[i].UpdateFill(false)

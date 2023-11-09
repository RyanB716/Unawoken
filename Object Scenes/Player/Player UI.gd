extends CanvasLayer

@export var StatueMenu : Statue_Menu

func _ready():
	pass

func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true

extends CanvasLayer

@export var StatueMenu : Statue_Menu

func _ready():
	StatueMenu.visible = false

func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true

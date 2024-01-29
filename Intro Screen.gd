extends Control

@export var GD : TextureRect
@export var RB : TextureRect

func _ready():
	RB.visible = false
	await get_tree().create_timer(3.5).timeout
	GoToRB()
	await get_tree().create_timer(3.5).timeout
	GoToMenu()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if RB.visible == false:
			GoToRB()
		else:
			GoToMenu()

func GoToRB():
	GD.visible = false
	RB.visible = true

func GoToMenu():
	get_tree().change_scene_to_file("res://Game Management/Scenes/MainMenu.tscn")

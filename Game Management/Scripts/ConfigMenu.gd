extends Control

func _ready():
	if GameSettings.PlayIntro == true:
		$VBoxContainer/CheckIntro.button_pressed = true
	else:
		$VBoxContainer/CheckIntro.button_pressed = false
	
	#$VBoxContainer.get_child(1).grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		GoBack()
		
	if Input.get_joy_name(0):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func SetIntro():
	GameSettings.PlayIntro = !GameSettings.PlayIntro
	
func GoBack():
	get_tree().change_scene_to_file("res://Game Management/Scenes/Menus/MainMenu.tscn")

func OpenControls():
	get_tree().change_scene_to_file("res://Game Management/Scenes/Menus/ControlsList.tscn")

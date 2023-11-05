extends Control

func _ready():
	if GameSettings.PlayIntro == true:
		$VBoxContainer/CheckIntro.button_pressed = true
	else:
		$VBoxContainer/CheckIntro.button_pressed = false
		
	$VBoxContainer/BackButton.grab_focus()

func CheckIntro():
	GameSettings.PlayIntro = !GameSettings.PlayIntro
	print(GameSettings.PlayIntro)
	
func GoBack():
	get_tree().change_scene_to_file("res://Game Management/Scenes/MainMenu.tscn")

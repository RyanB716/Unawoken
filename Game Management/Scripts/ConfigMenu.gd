extends Control

func _ready():
	$VBoxContainer/CheckIntro.button_pressed = true

func CheckIntro():
	GameSettings.PlayIntro = !GameSettings.PlayIntro
	print(GameSettings.PlayIntro)
	
func GoBack():
	get_tree().change_scene_to_file("res://Game Management/Scenes/MainMenu.tscn")

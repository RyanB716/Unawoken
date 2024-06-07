extends Control

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().change_scene_to_file("res://Game Management/Scenes/Menus/ConfigMenu.tscn")

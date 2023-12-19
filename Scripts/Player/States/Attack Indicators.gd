extends HBoxContainer
class_name Attack_Indicators

@export var Icon : PackedScene

func UpdateIcons(Amount : int):
	for i in get_child_count():
		get_child(i).queue_free()
	
	for i in Amount:
		AddIcon()

func AddIcon():
	var newIcon = Icon.instantiate()
	add_child(newIcon)

extends Panel

@onready var FilledIcon = preload("res://Assets/StamCircle_Filled.png")
@onready var EmptyIcon = preload("res://Assets/StamCircle_Empty.png")

@onready var sprite = $Sprite2D

func UpdateFill(IsFilled : bool):
	if IsFilled:
		sprite.texture = FilledIcon
	else:
		sprite.texture = EmptyIcon

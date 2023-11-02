extends Panel

@export var FilledIcon : Texture
@export var EmptyIcon : Texture

@onready var sprite = $Sprite2D

func UpdateFill(IsFilled : bool):
	if IsFilled:
		sprite.texture = FilledIcon
	else:
		sprite.texture = EmptyIcon

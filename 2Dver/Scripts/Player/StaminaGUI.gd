extends Panel

@export var FilledIcon : Texture
@export var EmptyIcon : Texture

@onready var texture : TextureRect = $TextureRect
@onready var IsFilled : bool = true

func _process(_delta):
	if IsFilled:
		texture.texture = FilledIcon
	else:
		texture.texture = EmptyIcon

extends TextureRect

@export var CircleFilled : Texture
@export var CircleEmpty : Texture

var IsFilled = true

func _process(delta):
	if IsFilled == true:
		self.texture = CircleFilled
	else:
		self.texture = CircleEmpty

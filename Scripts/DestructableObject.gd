extends StaticBody2D
class_name DestructableObject

@export var NumberOfHits : int
@export var DestroyedImage : Texture

@onready var CurrentHits : int = 0

func _process(delta):
	if NumberOfHits == 0:
		DestroyThisObject()
		
func DestroyThisObject():
	print("Destroying Object!")

extends Area2D
class_name HitBox

@onready var Parent

func _ready():
	Parent = get_parent()
	Parent.TakenHit.connect(OnHit)
	
func OnHit():
	print(str(Parent.name) + " has been hit!")

extends Area2D
class_name DestructableObject

@export var NeededHits : int
var CurrentHits : int

func _ready():
	CurrentHits = 0

func _process(delta):
	if CurrentHits == NeededHits:
		Destroy()

func Destroy():
	pass

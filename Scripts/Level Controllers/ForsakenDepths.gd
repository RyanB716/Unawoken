extends Node2D
class_name LevelController

var objects : Array[Node]

var Destructables : Array[DestructableObject]

func _ready():
	objects = $Destructables.get_children()
	
	for i in objects.size():
		if objects[i] is DestructableObject:
			Destructables.append(objects[i])

func _process(_delta):
	if !$"Audio/Ambient Audio 1".playing:
		$"Audio/Ambient Audio 1".play()
		
	if !$"Audio/Ambient Audio 2".playing:
		$"Audio/Ambient Audio 2".play()

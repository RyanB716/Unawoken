extends Node2D
class_name LevelController

var Destructables : Array[DestructableObject]

func _ready():
	for i in $Destructables.get_child_count():
		if $Destructables.get_child(i) is DestructableObject:
			Destructables.append($Destructables.get_child(i))

func _process(_delta):
	if !$"Audio/Ambient Audio 1".playing:
		$"Audio/Ambient Audio 1".play()
		
	if !$"Audio/Ambient Audio 2".playing:
		$"Audio/Ambient Audio 2".play()

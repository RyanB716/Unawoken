extends Node2D
class_name LevelController

@onready var GM : GameManager = get_parent()

var Destructables : Array[DestructableObject]

var Enemies : Array[BasicEnemy]

func _ready():
	for i in $Destructables.get_child_count():
		if $Destructables.get_child(i) is DestructableObject:
			Destructables.append($Destructables.get_child(i))
			
	for i in $Enemies.get_child_count():
		if $Enemies.get_child(i) is BasicEnemy:
			GM.HitNewTier.connect($Enemies.get_child(i).AnxietyEffect)
			Enemies.append($Enemies.get_child(i))

func _process(_delta):
	if !$"Audio/Ambient Audio 1".playing:
		$"Audio/Ambient Audio 1".play()
		
	if !$"Audio/Ambient Audio 2".playing:
		$"Audio/Ambient Audio 2".play()

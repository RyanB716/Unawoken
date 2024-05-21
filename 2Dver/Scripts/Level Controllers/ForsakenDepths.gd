extends Node2D
class_name LevelController

signal AllowFill()

@onready var GM : GameManager = get_parent()

var Destructables : Array[DestructableObject]

var Enemies : Array[BasicEnemy]

@export var AreaName : String

@onready var Ambient1 : AudioStreamPlayer = $"Audio/Ambient Audio 1"
@onready var Ambient2 : AudioStreamPlayer = $"Audio/Ambient Audio 2"

func _ready():
	for i in $Destructables.get_child_count():
		if $Destructables.get_child(i) is DestructableObject:
			Destructables.append($Destructables.get_child(i))
			
	#print("Destructable Drop at 0 at 0 is" + str(Destructables[0].ItemDrops[0]))
	
	for i in $Enemies.get_child_count():
		if $Enemies.get_child(i) is BasicEnemy:
			GM.AnxietyUpdate.connect($Enemies.get_child(i).AnxietyEffect)
			Enemies.append($Enemies.get_child(i))

func _on_anxiety_trigger_body_entered(body):
	if body is Player:
		if GameSettings.ShouldFillAnxiety == false:
			GameSettings.ShouldFillAnxiety = true
			AllowFill.emit()

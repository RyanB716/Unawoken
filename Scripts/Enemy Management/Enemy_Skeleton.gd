extends BasicEnemy
class_name EnemySkeleton

@onready var AnimPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	pass

func _physics_process(delta):
	move_and_slide()

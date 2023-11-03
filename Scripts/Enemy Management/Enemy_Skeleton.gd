extends BasicEnemy
class_name Skeleton

@onready var AnimPlayer = $AnimationPlayer

func _physics_process(delta):
	move_and_slide()

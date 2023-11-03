extends State
class_name Enemy_Follow

@export var SelfRef : BasicEnemy
@onready var PlayerTarget : Player

func OnEnter():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	
func PhysicsUpdate(_deta : float):
	if PlayerTarget != null:
		var Direction = PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() > 20.0:
			SelfRef.velocity = Direction.normalized() * SelfRef.TopSpeed
		else:
			SelfRef.velocity = Vector2.ZERO

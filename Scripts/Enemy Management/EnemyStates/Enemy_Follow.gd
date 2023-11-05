extends State
class_name Enemy_Follow

@export var SelfRef : BasicEnemy

func OnEnter():
	print("Skeleton: FOLLOWING")
	
func PhysicsUpdate(_deta : float):
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() > SelfRef.AttackRange:
			SelfRef.velocity = Direction.normalized() * SelfRef.TopSpeed
		else:
			Transitioned.emit("Attack")
			
		if Direction.length() > SelfRef.DisengagementRange:
			Transitioned.emit("Idle")

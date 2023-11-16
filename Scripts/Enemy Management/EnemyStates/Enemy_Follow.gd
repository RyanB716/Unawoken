extends State
class_name Enemy_Follow

@export var SelfRef : BasicEnemy

var Direction
	
func PhysicsUpdate(_deta : float):
	Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
	if Direction.length() > SelfRef.AttackRange:
		SelfRef.velocity = Direction.normalized() * SelfRef.TopSpeed
	else:
		Transitioned.emit("Attack")
			
	if Direction.length() > SelfRef.DisengagementRange:
		Transitioned.emit("Idle")
			
	if Direction.y > -0.1:
		SelfRef.z_index = 0
	else:
		SelfRef.z_index = 2

func DecideToAttack():
	var RNG = RandomNumberGenerator.new()
	
	var newValue = RNG.randi_range(0, 100)
	
	if newValue >= 75:
		Transitioned.emit("Attack")
	else:
		if Direction.length() > SelfRef.DisengagementRange:
			Transitioned.emit("Idle")

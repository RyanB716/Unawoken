extends State
class_name Enemy_Idle

@export var SelfRef : BasicEnemy
var ChangeTime : float

func OnEnter():
	ChangeTime = 3.0

func Update(delta : float):
	if ChangeTime > 0:
		ChangeTime -= delta
	else:
		ChangeToWander()
		
func PhysicsUpdate(_delta : float):
	
	SelfRef.velocity = Vector2.ZERO
	
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() < SelfRef.DetectionRange && SelfRef.IsDead == false:
			Transitioned.emit("Follow")
	
func ChangeToWander():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue <= 0.75:
		Transitioned.emit("Wander")
	else:
		ChangeTime = RNG.randf_range(0, 5)
	

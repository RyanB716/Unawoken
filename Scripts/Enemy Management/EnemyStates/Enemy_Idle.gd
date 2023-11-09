extends State
class_name Enemy_Idle

@export var SelfRef : BasicEnemy
var ChangeTime : float

func OnEnter():
	ChangeTime = 3.0

func Update(delta : float):
	var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
	if SelfRef.AnimPlayer:
		if Direction.x > 0:
			SelfRef.AnimPlayer.play("Skeleton_Idle_R")
		elif Direction.x < 0:
			SelfRef.AnimPlayer.play("Skeleton_Idle_L")
		
	if ChangeTime > 0:
		ChangeTime -= delta
	else:
		ChangeToWander()
		
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
		
func PhysicsUpdate(_delta : float):
	
	SelfRef.velocity = Vector2.ZERO
	
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() < SelfRef.DetectionRange:
			Transitioned.emit("Follow")
	
func ChangeToWander():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue <= 0.75:
		Transitioned.emit("Wander")
	else:
		ChangeTime = RNG.randf_range(0, 5)
	

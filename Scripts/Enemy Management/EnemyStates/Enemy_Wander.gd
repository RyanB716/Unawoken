extends State
class_name Enemy_Wander

@export var SelfRef : BasicEnemy

var MoveDirection : Vector2
var WanderTime : float

func OnEnter():
	print("Skelton: WANDERING!")

func Update(delta : float):
	if WanderTime > 0:
		WanderTime -= delta
		
	else:
		RandomizeTime()
		
func PhysicsUpdate(_delta : float):
	if SelfRef:
		SelfRef.velocity = (MoveDirection * SelfRef.BaseSpeed)
		
func RandomizeTime():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue >= 0.75:
		print("Transitioning to IDLE")
		SelfRef.velocity = Vector2.ZERO
		Transitioned.emit("Idle")
	else:
		MoveDirection = Vector2(RNG.randf_range(-1, 1), RNG.randf_range(-1, 1)).normalized()
		WanderTime = RNG.randf_range(0.5, 3.0)
		
		SelfRef.velocity = MoveDirection * SelfRef.BaseSpeed

extends State
class_name Enemy_Wander

@export var SelfRef : EnemySkeleton

var MoveDirection : Vector2
var WanderTime : float

func OnEnter():
	print("Wandering!")

func Update(delta : float):
	if WanderTime > 0:
		WanderTime -= delta
		
	else:
		RandomizeTime()
		
	if SelfRef.AnimPlayer:
		SelfRef.AnimPlayer.play("Skeleton_Walk")
		if MoveDirection.x >= 0.01:
			SelfRef.sprite.flip_h = false
		else:
			SelfRef.sprite.flip_h = true
		
func PhysicsUpdate(_delta : float):
	if SelfRef:
		SelfRef.velocity = (MoveDirection * SelfRef.BaseSpeed)
		
func RandomizeTime():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue >= 0.75:
		print("Transitioning to IDLE")
		SelfRef.velocity = Vector2.ZERO
		Transitioned.emit("Enemy_Idle")
	else:
		MoveDirection = Vector2(RNG.randf_range(-1, 1), RNG.randf_range(-1, 1)).normalized()
		WanderTime = RNG.randf_range(0.5, 3.0)
		
		SelfRef.velocity = MoveDirection * SelfRef.BaseSpeed

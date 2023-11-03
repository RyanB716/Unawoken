extends State
class_name Enemy_Wander

@export var Anim : AnimationPlayer
@export var SelfRef : BasicEnemy
@export var sprite : Sprite2D

var MoveDirection : Vector2
var WanderTime : float

func OnEnter():
	print("Wandering!")
	Anim.play("Skeleton_Walk")

func Update(delta : float):
	if WanderTime > 0:
		WanderTime -= delta
		
	else:
		RandomizeTime()
		
func PhysicsUpdate(delta : float):
	if SelfRef:
		SelfRef.velocity = (MoveDirection * SelfRef.BaseSpeed)
		
func RandomizeTime():
	var RNG = RandomNumberGenerator.new()
	MoveDirection = Vector2(RNG.randf_range(-1, 1), RNG.randf_range(-1, 1)).normalized()
	WanderTime = RNG.randf_range(0.5, 3.0)
	
	if MoveDirection.x >= 0.01:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
	SelfRef.velocity = MoveDirection * SelfRef.BaseSpeed

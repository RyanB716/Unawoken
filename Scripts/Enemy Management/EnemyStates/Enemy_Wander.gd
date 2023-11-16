extends State
class_name Enemy_Wander

@export var SelfRef : BasicEnemy

var MoveDirection : Vector2
var WanderTime : float

func Update(delta : float):
	if WanderTime > 0:
		WanderTime -= delta
		
	else:
		RandomizeTime()
		
func PhysicsUpdate(_delta : float):
	if SelfRef:
		SelfRef.velocity = (MoveDirection * SelfRef.BaseSpeed)
		
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() < SelfRef.DetectionRange:
			Transitioned.emit("Follow")
		
func RandomizeTime():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue >= 0.75:
		SelfRef.velocity = Vector2.ZERO
		Transitioned.emit("Idle")
	else:
		var newDirection = RNG.randi_range(0, 3)
		match newDirection:
			0:
				SelfRef.CurrentDirection = SelfRef.DirectionStates.Up
				MoveDirection = Vector2.UP
			1:
				SelfRef.CurrentDirection = SelfRef.DirectionStates.Down
				MoveDirection = Vector2.DOWN
			2:
				SelfRef.CurrentDirection = SelfRef.DirectionStates.Left
				MoveDirection = Vector2.LEFT
			3:
				SelfRef.CurrentDirection = SelfRef.DirectionStates.Right
				MoveDirection = Vector2.RIGHT
				
		WanderTime = RNG.randf_range(0.5, 3.0)

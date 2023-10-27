extends CharacterBody2D

@onready var SpriteAnimator = $AnimationPlayer

enum DirectionStates {Up, Down, Left, Right}
enum MoveStates {Idle, Run}
enum AttackStates {NotAttacking, Attack1}

var CurrentMoveState : int
var CurrentDirection : int
var CurrentAttackState : int

var IsMoving = false

@export var TopSpeed = 0
@export var Acceleration = 0.0
@export var Deceleration = 0.0

var CurrentSpeed = 0
var HorizontalInput = 0
var VerticalInput = 0
var Direction = Vector2.ZERO

func _ready():
	CurrentMoveState = MoveStates.Idle
	CurrentDirection = DirectionStates.Down
	CurrentAttackState = AttackStates.NotAttacking
	
func _process(delta):
	match CurrentDirection:
		0:
			if IsMoving:
				$AnimationPlayer.play("Run_Up")
			else:
				$AnimationPlayer.play("Idle_Up")
		1:
			if IsMoving:
				$AnimationPlayer.play("Run_Down")
			else:
				$AnimationPlayer.play("Idle_Down")
		2:
			if IsMoving:
				$AnimationPlayer.play("Run_Left")
			else:
				$AnimationPlayer.play("Idle_Left")
		3:
			if IsMoving:
				$AnimationPlayer.play("Run_Right")
			else:
				$AnimationPlayer.play("Idle_Right")

func _physics_process(delta):
	
	IsMoving = Input.is_action_pressed("Run_Up") || Input.is_action_pressed("Run_Down") || Input.is_action_pressed("Run_Left") || Input.is_action_pressed("Run_Right")
	
	if IsMoving:
		HorizontalInput = int(Input.is_action_pressed("Run_Right")) - int(Input.is_action_pressed("Run_Left"))
		VerticalInput = int(Input.is_action_pressed("Run_Down")) - int(Input.is_action_pressed("Run_Up"))
		
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, Acceleration * delta)
		CurrentMoveState = MoveStates.Run
		
	else:
		CurrentSpeed = lerpf(CurrentSpeed, 0, Deceleration * delta)
		CurrentMoveState = MoveStates.Idle
	
	Direction = Vector2(HorizontalInput, VerticalInput).normalized()
	velocity = (Direction * CurrentSpeed)
	move_and_slide()
	GetSpriteDirection()
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
		
func GetSpriteDirection():
	match Direction:
		Vector2.DOWN:
			CurrentDirection = DirectionStates.Down
		Vector2.UP:
			CurrentDirection = DirectionStates.Up
		Vector2.RIGHT:
			CurrentDirection = DirectionStates.Right
		Vector2.LEFT:
			CurrentDirection = DirectionStates.Left

func Attack():
	CurrentAttackState = AttackStates.Attack1

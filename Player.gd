extends CharacterBody2D

@onready var SpriteAnimator = $AnimationPlayer

enum DirectionStates {Up, Down, Left, Right}
enum MoveStates {Idle, Run}
enum AttackStates {Idle, Attack1}

var CurrentMoveState : int
var CurrentDirection : int
var CurrentAttackState : int

@export var TopSpeed = 300.0
@export var Acceleration = 1
@export var Deceleration = 0.5
var CurrentSpeed = 0
var direction

func _ready():
	CurrentMoveState = MoveStates.Idle
	CurrentDirection = DirectionStates.Down
	CurrentAttackState = AttackStates.Idle

func _physics_process(delta):
	direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down")
	if direction != Vector2(0,0):
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, Acceleration * delta)
		velocity = (direction * CurrentSpeed)
		CurrentMoveState = MoveStates.Run
	else:
		CurrentSpeed = lerpf(CurrentSpeed, 0, Deceleration * delta)
		CurrentMoveState = MoveStates.Idle
		velocity = (direction * CurrentSpeed)

	move_and_slide()
	GetSpriteDirection()
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
		
func GetSpriteDirection():
	match direction:
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

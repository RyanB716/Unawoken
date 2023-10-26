extends CharacterBody2D

enum DirectionStates {Up, Down, Left, Right}
enum ActionStates {Idle, Run, Attack}

var CurrentMoveState : int
var CurrentDirection : int

@export var TopSpeed = 300.0
var CurrentSpeed = 0
var direction

func _ready():
	CurrentMoveState = ActionStates.Idle
	CurrentDirection = DirectionStates.Down

func _physics_process(delta):
	direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down")
	if direction != Vector2(0,0):
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, 1.75 * delta)
		velocity = direction * CurrentSpeed
		CurrentMoveState = ActionStates.Run
	else:
		velocity = Vector2(0, 0)
		CurrentSpeed = 0
		CurrentMoveState = ActionStates.Idle

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
	CurrentMoveState = ActionStates.Attack

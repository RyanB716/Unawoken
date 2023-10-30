extends CharacterBody2D

@onready var AnimTree = $AnimationTree
@onready var AttackTimer = $AttackStateTimer
@onready var B_Audio = $BodyAudio
@onready var W_Audio = $WeaponAudio

enum DirectionStates {Up, Down, Left, Right}
enum MoveStates {Idle, Run}

var CurrentMoveState : int
var CurrentDirection : int

var IsMoving = false
var IsAttacking = false

@export var TopSpeed = 0
@export var Acceleration = 0.0
@export var Deceleration = 0.0

var CurrentSpeed = 0
var HorizontalInput = 0
var VerticalInput = 0
var Direction = Vector2.ZERO

var AnimState = null

func _ready():
	CurrentMoveState = MoveStates.Idle
	CurrentDirection = DirectionStates.Down
	
	AnimState = AnimTree.get("parameters/playback")

func _physics_process(delta):
	IsMoving = Input.is_action_pressed("Run_Up") || Input.is_action_pressed("Run_Down") || Input.is_action_pressed("Run_Left") || Input.is_action_pressed("Run_Right")
	
	if IsMoving:
		HorizontalInput = int(Input.is_action_pressed("Run_Right")) - int(Input.is_action_pressed("Run_Left"))
		VerticalInput = int(Input.is_action_pressed("Run_Down")) - int(Input.is_action_pressed("Run_Up"))
		
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, Acceleration * delta)
		CurrentMoveState = MoveStates.Run
		
		if IsAttacking == true:
			AnimState.travel("Attack")
		else:
			AnimState.travel("Run")
		
	else:
		CurrentSpeed = lerpf(CurrentSpeed, 0, Deceleration * delta)
		CurrentMoveState = MoveStates.Idle
		AnimState.travel("Idle")
	
	Direction = Vector2(HorizontalInput, VerticalInput).normalized()
	velocity = (Direction * CurrentSpeed)
	
	AnimTree.set("parameters/Idle/blend_position", Direction)
	AnimTree.set("parameters/Run/blend_position", Direction)
	AnimTree.set("parameters/Attack/blend_position", Direction)
	
	move_and_slide()
	GetSpriteDirection()
	
	if Input.is_action_just_pressed("Attack"):
		if IsAttacking == false:
			Attack()
		else:
			print("Can NOT attack!")
	
	pass
		
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
	await get_tree().create_timer(0.15).timeout
	print("Attacking")
	IsAttacking = true
	await $AnimationTree.animation_finished
	print("Can attack")
	IsAttacking = false

extends CharacterBody3D
class_name Player

@export_category("Movement")
@export var JogSpeed: float = 10.0
@export var JumpHeight: float = 25.0
@export var GravityStrength: float = 50.0

@onready var mesh: CharacterMesh = $Mesh
@onready var CamBoom: SpringArm3D = $"Camera Boom"

enum eMoveStates
{
	Dead,
	Idle,
	Moving,
	Jumping,
	Rolling
}

var CurrentMoveState: eMoveStates

var CurrentDirection: Vector3

func _ready():
	CurrentMoveState = eMoveStates.Idle
	
func _process(delta):
	if CurrentMoveState == eMoveStates.Dead:
		return
	
func _physics_process(delta):
	var CurrentDirection: Vector3 = Vector3.ZERO
	CurrentDirection.x = Input.get_action_strength("Move Right") - Input.get_action_strength("Move Left")
	CurrentDirection.y = Input.get_action_strength("Move Back") - Input.get_action_strength("Move Forward")
	CurrentDirection = CurrentDirection.rotated(Vector3.UP, CamBoom.rotation.y).normalized()
	
	
	velocity.x = CurrentDirection.x * JogSpeed
	velocity.z = CurrentDirection.z * JogSpeed
	velocity.y -= GravityStrength * delta
	move_and_slide()

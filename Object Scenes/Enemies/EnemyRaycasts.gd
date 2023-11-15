extends Node2D

@export var ParentRef : BasicEnemy

@onready var RC_Up = $RC_Up
@onready var RC_Down = $RayCast2D
@onready var RC_Left = $RC_Left
@onready var RC_Right = $RC_Right

func _ready():
	RC_Up.target_position = Vector2(0, ParentRef.DetectionRange)
	RC_Down.target_position = Vector2(0, -ParentRef.DetectionRange)
	RC_Left.target_position = Vector2(ParentRef.DetectionRange, 0)
	RC_Right.target_position = Vector2(-ParentRef.DetectionRange, 0)
	
func _physics_process(delta):
	if RC_Up.is_colliding():
		if RC_Up.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Down
	if RC_Down.is_colliding():
		if RC_Down.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Up
	if RC_Left.is_colliding():
		if RC_Left.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Right
	if RC_Right.is_colliding():
		if RC_Right.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Left

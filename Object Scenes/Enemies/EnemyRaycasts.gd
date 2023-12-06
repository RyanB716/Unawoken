extends Node2D

@export var ParentRef : BasicEnemy

@onready var North = $RC_N
@onready var South = $RC_S
@onready var West = $RC_W
@onready var East = $RC_E

@onready var NorthEast = $RC_NE
@onready var NorthWest = $RC_NW
@onready var SouthEast = $RC_SE
@onready var SouthWest = $RC_SW

func _ready():
	North.target_position = Vector2(0, ParentRef.DetectionRange)
	South.target_position = Vector2(0, -ParentRef.DetectionRange)
	West.target_position = Vector2(ParentRef.DetectionRange, 0)
	East.target_position = Vector2(-ParentRef.DetectionRange, 0)
	
	NorthEast.target_position = Vector2(ParentRef.DetectionRange, 0)
	NorthWest.target_position = Vector2(-ParentRef.DetectionRange, 0)
	SouthEast.target_position = Vector2(0, ParentRef.DetectionRange)
	SouthWest.target_position = Vector2(0, ParentRef.DetectionRange)
	
func _physics_process(_delta):
	if North.is_colliding():
		if North.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Down
	elif South.is_colliding():
		if South.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Up
			
	elif West.is_colliding() or SouthEast.is_colliding() or NorthEast.is_colliding():
		if East.get_collider() is Player or SouthEast.get_collider() is Player or NorthEast.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Right
	elif East.is_colliding() or NorthWest.is_colliding() or SouthWest.is_colliding():
		if West.get_collider() is Player or NorthWest.get_collider() is Player or SouthWest.get_collider() is Player:
			ParentRef.CurrentDirection = ParentRef.DirectionStates.Left

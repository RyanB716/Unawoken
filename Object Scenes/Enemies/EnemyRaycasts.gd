extends Node2D

@export var ParentRef : BasicEnemy

@onready var RC_Up = $RC_Up
@onready var RC_Down = $RayCast2D
@onready var RC_Left = $RC_Left
@onready var RC_Right = $RC_Right

func ready():
	RC_Up.target_position = Vector2(0, ParentRef.DetectionRange)
	RC_Down.target_position = Vector2(0, -ParentRef.DetectionRange)
	RC_Left.target_position = Vector2(-ParentRef.DetectionRange, 0)
	RC_Right.target_position = Vector2(ParentRef.DetectionRange, 0)

func SendRaycasts():
	$RayTimer.start(0.5)
	for i in self.get_child_count() - 1:
		pass

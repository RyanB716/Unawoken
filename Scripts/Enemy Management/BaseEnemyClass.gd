extends CharacterBody2D
class_name BasicEnemy

@export_category("Combat Stats")
@export var MaxHealth : int
@export var NumberOfAttacks : int
@export var DamageMinimum : int
@export var DamageMaximum : int

@export_category("Movement Stats")
@export var BaseSpeed : float
@export var TopSpeed : float

@export_category("Surveilance Stats")
@export var DetectionRange : float

func _physics_process(_delta):
	move_and_slide()

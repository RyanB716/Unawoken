extends Area2D
class_name HitBox

@export var TargetReference : BasicEnemy

func TakeDamage(Amnt : int):
	TargetReference.CurrentHealth -= Amnt

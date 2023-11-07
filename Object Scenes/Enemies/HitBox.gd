extends Area2D
class_name HitBox

@export var ParentRef : Node2D

func TakeDamage(DMG : int):
	ParentRef.CurrentHealth = ParentRef.CurrentHealth - DMG

extends Area2D
class_name HitBox

@export var TargetReference : CharacterBody2D

func TakeDamage(Amnt : int):
	TargetReference.CurrentHealth -= Amnt

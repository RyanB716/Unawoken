extends Area2D
class_name HitBox

@export var TargetReference : CharacterBody2D

func _ready():
	if self.get_child(0).disabled == true:
		self.get_child(0).disabled = false

func TakeDamage(Amnt : int):
	TargetReference.CurrentHealth -= Amnt

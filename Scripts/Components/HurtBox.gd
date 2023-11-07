extends Area2D
class_name HurtBox

@export var TargetReference : CharacterBody2D

func _ready():
	self.get_child(0).disabled = true

func WeaponHit(target : Area2D):
	if target is HitBox:
		if target.TargetReference != self.TargetReference:
			target.TakeDamage(TargetReference.DamageOutput)

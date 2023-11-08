extends Area2D
class_name HurtBox

@export var TargetReference : CharacterBody2D

func _ready():
	self.get_child(0).disabled = true

func WeaponHit(target : Area2D):
	if target is HitBox:
		if target.TargetReference != self.TargetReference:
			target.TakeDamage(TargetReference.DamageOutput)
			
	if target is DestructableObject:
		target.CurrentHits += 1
		if (target.CurrentHits + 1) == target.NeededHits:
			var GameCamera = get_tree().get_first_node_in_group("Cameras")
			print(GameCamera)

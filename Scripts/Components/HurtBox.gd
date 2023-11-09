extends Area2D
class_name HurtBox

@export var TargetReference : CharacterBody2D

func _ready():
	self.get_child(0).disabled = true

func WeaponHit(target : Area2D):
	if target is HitBox && target.TargetReference != self.TargetReference:
		target.TakeDamage(TargetReference.DamageOutput)
		if target.TargetReference != Player:
			get_tree().get_first_node_in_group("GameManager").HitStop(0.25)
			
	if target is DestructableObject:
		if (target.CurrentHits + 1) == target.NeededHits:
			target.PlayBreakSFX()
			var GameCamera = get_tree().get_first_node_in_group("Cameras")
			print(GameCamera)
		else:
			target.PlayHitSFX()
			
		target.CurrentHits += 1

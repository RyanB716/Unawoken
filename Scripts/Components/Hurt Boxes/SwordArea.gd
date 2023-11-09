extends HurtBox
class_name PlayerSwordBox

@export var SelfReference : Player

func WeaponHit(target : Area2D):
	if target is EnemyHitBox:
		target.TakeDamage(SelfReference.DamageOutput)
		get_tree().get_first_node_in_group("GameManager").HitStop(0.15)
			
	if target is DestructableObject:
		if (target.CurrentHits + 1) == target.NeededHits:
			target.PlayBreakSFX()
			var GameCamera = get_tree().get_first_node_in_group("Cameras")
			print(GameCamera)
		else:
			target.PlayHitSFX()
			
		target.CurrentHits += 1

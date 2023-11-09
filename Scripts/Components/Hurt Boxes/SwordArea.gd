extends HurtBox
class_name PlayerSwordBox

@export var SelfReference : Player

func WeaponHit(target : Area2D):
	if target is EnemyHitBox:
		if target.get_parent().CurrentHealth - SelfReference.DamageOutput >= 1:
			target.TakeDamage(SelfReference.DamageOutput)
			get_tree().get_first_node_in_group("GameManager").HitStop(0.15)
			await get_tree().create_timer(0.15).timeout
			GameCamera.ApplyShake(1.75, 0.2)
		else:
			print("Target should be dead")
			target.TakeDamage(SelfReference.DamageOutput)
			get_tree().get_first_node_in_group("GameManager").HitStop(0.15)
			await get_tree().create_timer(0.15).timeout
			GameCamera.ApplyShake(2.5, 0.75)

	if target is DestructableObject:
		if (target.CurrentHits + 1) == target.NeededHits:
			target.PlayBreakSFX()
			GameCamera.ApplyShake(1.5, 0.25)
		else:
			GameCamera.ApplyShake(0.75, 0.15)
			target.PlayHitSFX()
			
		target.CurrentHits += 1

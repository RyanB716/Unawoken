extends HurtBox
class_name EnemyHurtBox

@export var SelfReference : BasicEnemy

func WeaponHit(target : Area2D):
	if target is PlayerHitBox:
		target.TakeDamage(SelfReference.DamageOutput)
		get_tree().get_first_node_in_group("GameManager").HitStop(0.25)
		await get_tree().create_timer(0.25).timeout
		GameCamera.ApplyShake(2.5, 0.5)

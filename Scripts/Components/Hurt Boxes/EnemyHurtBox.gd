extends HurtBox
class_name EnemyHurtBox

@export var SelfReference : BasicEnemy

func WeaponHit(target : Area2D):
	if target is PlayerHitBox:
		target.TakeDamage(SelfReference.DamageOutput)

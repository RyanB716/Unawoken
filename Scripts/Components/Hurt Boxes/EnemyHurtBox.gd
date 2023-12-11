extends HurtBox
class_name EnemyHurtBox

@export var SelfReference : BasicEnemy

#Checks if collided object is attached to a Player; calls take damage as well as hitstop effect
func WeaponHit(target : Area2D):
	if target is PlayerHitBox:
		var player = target.get_parent()
		if player is Player:
			target.TakeDamage(SelfReference.DamageOutput)
			target.PlaySFX()
			get_tree().get_first_node_in_group("GameManager").HitStop(0.5)
			GameCamera.ApplyShake(2.75, 0.5)
			if player.CurrentHealth <= 0:
				player.Die()
			else:
				return

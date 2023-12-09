extends HurtBox
class_name PlayerSwordBox

@export var SelfReference : Player

#checks if object is an enemy or an object, and executes context specific commands
func WeaponHit(target : Area2D):
	if target is EnemyHitBox:
		
		var kbDir : Vector2
		match SelfReference.CurrentDirection:
			0:
				kbDir = Vector2.UP
			1:
				kbDir = Vector2.DOWN
			2:
				kbDir = Vector2.LEFT
			3:
				kbDir = Vector2.RIGHT
				
		target.SelfRef.SetKnockBack(150, 0.25, kbDir)
		
		target.PlaySFX()
		if target.get_parent().CurrentHealth - SelfReference.DamageOutput >= 1:
			target.TakeDamage(SelfReference.DamageOutput)
			get_tree().get_first_node_in_group("GameManager").HitStop(0.25)
			GameCamera.ApplyShake(1.75, 0.2)
		else:
			target.TakeDamage(SelfReference.DamageOutput)
			get_tree().get_first_node_in_group("GameManager").HitStop(0.5)
			GameCamera.ApplyShake(2.5, 0.75)

	elif target.get_parent() is DestructableObject:
		var object = target.get_parent()
		if object.CurrentHits + 1 >= object.NeededHits:
			GameCamera.ApplyShake(1.5, 0.25)
			object.Destroy()
		else:
			GameCamera.ApplyShake(0.75, 0.15)
			object.PlayHitSFX()
			
		object.CurrentHits += 1

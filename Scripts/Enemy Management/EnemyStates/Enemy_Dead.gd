extends State
class_name Enemy_Dead

@export var SelfRef : BasicEnemy

func OnEnter():
	print("Enemy Dead")
	SelfRef.velocity = Vector2.ZERO
	SelfRef.AnimPlayer.play("Skeleton_Death")
	SelfRef.HealthBar.visible = false
	SelfRef.HitBoxColl.disabled = true
	SelfRef.HurtBoxColl.disabled = true
	SelfRef.EnvironmentCollider.disabled = true

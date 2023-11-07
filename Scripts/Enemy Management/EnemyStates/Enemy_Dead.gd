extends State
class_name Enemy_Dead

@export var SelfRef : BasicEnemy

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	SelfRef.z_index = 0
	SelfRef.AnimPlayer.play("Skeleton_Death")
	SelfRef.HealthBar.visible = false
	SelfRef.HitBoxCollider.disabled = true
	SelfRef.EnvironmentCollider.disabled = true

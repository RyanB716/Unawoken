extends State
class_name Enemy_Dead

@export var SelfRef : BasicEnemy

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	SelfRef.z_index = 0
	#SelfRef.AnimPlayer.play("Death")
	SelfRef.HealthBar.visible = false
	SelfRef.HitBoxCollider.disabled = true
	SelfRef.EnvironmentCollider.disabled = true
	SelfRef.HurtBoxCollider.disabled = true
	await get_tree().create_timer(1.5).timeout
	SelfRef.sprite.visible = false

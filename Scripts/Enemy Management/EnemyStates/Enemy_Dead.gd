extends State
class_name Enemy_Dead

@export var SelfRef : BasicEnemy

func OnEnter():
	print(str(SelfRef.name) + " is DEAD")
	get_tree().get_first_node_in_group("Player").AddXP(SelfRef.XpAmount)
	SelfRef.velocity = Vector2.ZERO
	SelfRef.z_index = 0
	SelfRef.AnimPlayer.play("Idle/Idle_D")
	SelfRef.HealthBar.visible = false
	SelfRef.HitBoxCollider.disabled = true
	SelfRef.EnvironmentCollider.disabled = true
	SelfRef.HurtBoxCollider.disabled = true
	await get_tree().create_timer(0.5).timeout
	SelfRef.queue_free()

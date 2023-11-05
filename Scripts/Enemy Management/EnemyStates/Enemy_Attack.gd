extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

func OnEnter():
	print("Attacking")
	SelfRef.velocity = Vector2.ZERO
	SelfRef.AnimPlayer.play("Skeleton_Attack")
	SelfRef.AttackSFX.play()
	await SelfRef.AnimPlayer.animation_finished
	Transitioned.emit("Idle")

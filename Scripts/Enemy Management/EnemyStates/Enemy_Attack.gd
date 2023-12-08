extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

var Direction
var Distance

func OnEnter():
	SelfRef.IsAttacking = true
	SelfRef.velocity = Vector2.ZERO
	
	SelfRef.Raycasts.CheckCollisions()
	
	match SelfRef.CurrentDirection:
		0:
			SelfRef.AnimPlayer.play("Attack/Attack_U")
		1:
			SelfRef.AnimPlayer.play("Attack/Attack_D")
		2:
			SelfRef.AnimPlayer.play("Attack/Attack_L")
		3:
			SelfRef.AnimPlayer.play("Attack/Attack_R")
	
	await SelfRef.AnimPlayer.animation_finished
	SelfRef.IsAttacking = false
	Transitioned.emit("Follow")

extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

var Direction

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	
	Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
	if Direction.x > 0:
		SelfRef.AnimPlayer.play("Skeleton_Attack_R")
	elif Direction.x < 0:
		SelfRef.AnimPlayer.play("Skeleton_Attack_L")
		
	await SelfRef.AnimPlayer.animation_finished
	
	if SelfRef.CurrentHealth >= 1:
		if Direction.length() <= SelfRef.DetectionRange:
			Transitioned.emit("Follow")
		else:
			Transitioned.emit("Idle")
			
func Update(_delta : float):
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
	

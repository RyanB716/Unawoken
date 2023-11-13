extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

var Direction

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	
	Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	var NormDir = Direction.normalized()
	print(NormDir)
	if NormDir.x < NormDir.y:
		if NormDir.y >= 0.1:
			print("Attacking Down")
			SelfRef.AnimPlayer.play("Attack_D")
		else:
			print("Attacking Up")
			SelfRef.AnimPlayer.play("Attack_U")
	else:
		if NormDir.x <= 0.1:
			print("Attacking Left")
			SelfRef.AnimPlayer.play("Attack_L")
		else:
			print("Attacking Right")
			SelfRef.AnimPlayer.play("Attack_R")
		
	await SelfRef.AnimPlayer.animation_finished
	
	if SelfRef.CurrentHealth >= 1:
		if Direction.length() <= SelfRef.DetectionRange:
			Transitioned.emit("Follow")
		else:
			Transitioned.emit("Idle")
			
func Update(_delta : float):
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
	

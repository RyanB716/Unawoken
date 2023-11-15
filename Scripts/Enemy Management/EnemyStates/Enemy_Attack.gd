extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

var Direction

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	
	var Distance = SelfRef.global_position - SelfRef.PlayerTarget.global_position
	
	match SelfRef.CurrentDirection:
		0:
			SelfRef.AnimPlayer.play("Attack_U")
			if SelfRef.AnimPlayer.is_playing():
				print("Up")
		1:
			SelfRef.AnimPlayer.play("Attack_D")
			if SelfRef.AnimPlayer.is_playing():
				print("Down")
		2:
			SelfRef.AnimPlayer.play("Attack_L")
			if SelfRef.AnimPlayer.is_playing():
				print("Left")
		3:
			SelfRef.AnimPlayer.play("Attack_R")
			if SelfRef.AnimPlayer.is_playing():
				print("Right")
	
	#await get_tree().create_timer(0.25).timeout
	await SelfRef.AnimPlayer.animation_finished
	print("Attack finished!")
	
	if SelfRef.CurrentHealth >= 1:
		if Distance.length() <= SelfRef.DetectionRange:
			Transitioned.emit("Follow")
		else:
			Transitioned.emit("Idle")
			
func Update(_delta : float):
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
	

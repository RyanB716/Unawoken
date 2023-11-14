extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

var Direction

func OnEnter():
	SelfRef.velocity = Vector2.ZERO
	
	var Distance = SelfRef.global_position - SelfRef.PlayerTarget.global_position
	print(Distance)
	
	#await SelfRef.AnimPlayer.animation_finished
	
	if SelfRef.CurrentHealth >= 1:
		if Distance.length() <= SelfRef.DetectionRange:
			Transitioned.emit("Follow")
		else:
			Transitioned.emit("Idle")
			
func Update(_delta : float):
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
	

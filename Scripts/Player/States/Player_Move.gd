extends State
class_name Player_Move

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer

func Update(delta : float):
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Run_Up")
		1:
			AnimPlayer.play("Run_Down")
		2:
			AnimPlayer.play("Run_Left")
		3:
			AnimPlayer.play("Run_Right")

	if PlayerRef.CurrentSpeed < 0.15:
		Transitioned.emit(self, "Player_Idle")
	
	if Input.is_action_just_pressed("Attack"):
		Transitioned.emit(self, "Player_Attack1")
		
	if Input.is_action_just_pressed("Roll"):
		Transitioned.emit(self, "Roll")
